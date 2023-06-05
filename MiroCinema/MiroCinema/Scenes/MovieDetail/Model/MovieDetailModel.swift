//
//  MovieDetailController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import UIKit

final class MovieDetailModel {

    private let movie: Movie
    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()
    var movieDetail: MovieDetail?
    var movieCredits = MovieCredit.skeletonModels

    init(movie: Movie) {
        self.movie = movie
        fetchMovieDetails()
        fetchMovieCredits()
    }

    private func fetchMovieDetails() {
        guard let movieID = movie.ID else { return }
        let movieDetailEndPoint = MovieDetailsAPIEndPoint(movieCode: movieID)
        let movieCertificationEndPoint = MovieCertificationAPIEndPoint(movieCode: movieID)
        Task {
            do {
                let decodedDetailData = try await movieNetworkAPIManager.fetchData(
                    to: MovieDetailsDTO.self,
                    endPoint: movieDetailEndPoint
                )
                guard let movieInformation = decodedDetailData as? MovieDetailsDTO else { return }

                let decodedCertificationData = try await movieNetworkAPIManager.fetchData(
                    to: MovieCertificationDTO.self,
                    endPoint: movieCertificationEndPoint
                )
                guard let movieCertification = decodedCertificationData as? MovieCertificationDTO else { return }
                guard let posterPath = movieInformation.posterPath else { return }
                let cacheKey = NSString(string: posterPath)
                if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                    movieDetail = generateMovieDetail(with: movieInformation, movieCertification, cachedImage)
                } else {
                    let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
                    let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        ImageCacheManager.shared.setObject(posterImage, forKey: cacheKey)
                        movieDetail = generateMovieDetail(with: movieInformation, movieCertification, posterImage)
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name("MovieDetailModelDidFetchDetailData"),
                object: nil
            )
        }
    }

    private func fetchMovieCredits() {
        Task {
            do {
                guard let movieID = movie.ID else { return }
                let movieCreditsEndPoint = MovieCreditsAPIEndPoint(movieCode: movieID)
                let decodedData = try await movieNetworkAPIManager.fetchData(
                    to: MovieCreditsDTO.self,
                    endPoint: movieCreditsEndPoint
                )
                guard let credits = decodedData as? MovieCreditsDTO else { return }

                let sortedCredits = credits.cast.sorted { return $0.popularity > $1.popularity }

                for (index, actor) in sortedCredits.prefix(16).enumerated() {
                    let actorName = actor.name
                    let characterName = actor.characterName
                    let imageProfilePath = actor.profilePath ?? ""
                    let cachekey = NSString(string: imageProfilePath)
                    if let cachedImage = ImageCacheManager.shared.object(forKey: cachekey) {
                        movieCredits[index].profileImage = cachedImage
                    } else {
                        let imageProfilePathEndPoint = MovieImageAPIEndPoint(imageURL: imageProfilePath)
                        let actorImageResult = try await movieNetworkDispatcher.performRequest(imageProfilePathEndPoint.urlRequest)

                        switch actorImageResult {
                        case .success(let data):
                            guard let profileImage = UIImage(data: data) else { return }
                            ImageCacheManager.shared.setObject(profileImage, forKey: cachekey)
                            movieCredits[index].profileImage = profileImage
                        case .failure:
                            movieCredits[index].profileImage = UIImage(systemName: "person.fill")?
                                .withTintColor(.gray)
                                .withRenderingMode(.alwaysOriginal)
                        }
                    }
                    movieCredits[index].name = actorName
                    movieCredits[index].characterName = characterName
                }
            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name("MovieDetailModelDidFetchCreditData"),
                object: nil
            )
        }
    }

    private func generateMovieDetail(
        with movieDetailsDTO: MovieDetailsDTO,
        _ movieCertificationDTO: MovieCertificationDTO,
        _ posterImage: UIImage
    ) -> MovieDetail {

        let USACertification = movieCertificationDTO.certifications.first(
            where: { $0.countryCode == "US"}
        )
        let certification = USACertification?.information.first(where: {
            $0.certificationRate != ""
        })
        let rate = certification?.certificationRate ?? "NR"

        return MovieDetail(
            posterImage: posterImage,
            certificationRate: rate,
            koreanTitle: movieDetailsDTO.koreanTitle,
            originalTitle: movieDetailsDTO.originalTitle,
            releaseDate: movieDetailsDTO.releaseDate,
            countries: movieDetailsDTO.productionCountries,
            genres: movieDetailsDTO.genres,
            runtime: movieDetailsDTO.runTime,
            tagLine: movieDetailsDTO.tagLine,
            overview: movieDetailsDTO.overview
        )
    }
}
