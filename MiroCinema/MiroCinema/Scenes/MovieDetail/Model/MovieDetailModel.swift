//
//  MovieDetailController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import UIKit

final class MovieDetailModel {

    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()
    var movieDetail: MovieDetail?
    var movieCredits = MovieCredit.skeletonModels
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
        fetchMovieDetails()
        fetchMovieCredits()
    }

    private func fetchMovieDetails() {
        guard let movieID = movie.ID else { return }
        Task {
            do {
                guard let movieInformation = try await fetchMovieDetailInformation(movieID: movieID) else { return }
                guard let movieCertification = try await fetchMovieCertification(movieID: movieID) else { return }

                guard let posterPath = movieInformation.posterPath else { return }
                let resourceKey = MovieImage.poster(ID: movieInformation.ID).resourceKey

                if ImageCacheManager.shared.isCached(resourceKey: resourceKey) {
                    let cachedImage = ImageCacheManager.shared.value(forResoureceKey: resourceKey)
                    movieDetail = generateMovieDetail(with: movieInformation, movieCertification, cachedImage)
                } else {
                    movieDetail = try await movieDetail(
                        with: posterPath,
                        movieInformation: movieInformation,
                        movieCertification: movieCertification,
                        cacheKey: resourceKey
                    )
                }
            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name.detailModelDidFetchDetailData,
                object: nil
            )
        }
    }

    private func fetchMovieCertification(movieID: Int) async throws -> MovieCertificationDTO? {
        let movieCertificationEndPoint = MovieCertificationAPIEndPoint(movieCode: movieID)
        let decodedCertificationData = try await movieNetworkAPIManager.fetchData(
            to: MovieCertificationDTO.self,
            endPoint: movieCertificationEndPoint
        )
        let movieCertification = decodedCertificationData as? MovieCertificationDTO

        return movieCertification
    }

    private func fetchMovieDetailInformation(movieID: Int) async throws -> MovieDetailsDTO? {
        let movieDetailEndPoint = MovieDetailsAPIEndPoint(movieCode: movieID)
        let decodedDetailData = try await movieNetworkAPIManager.fetchData(
            to: MovieDetailsDTO.self,
            endPoint: movieDetailEndPoint
        )

        let movieInformation = decodedDetailData as? MovieDetailsDTO

        return movieInformation
    }

    private func movieDetail(
        with posterPath: String,
        movieInformation: MovieDetailsDTO,
        movieCertification: MovieCertificationDTO,
        cacheKey: String
    ) async throws -> MovieDetail? {
        let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
        let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)

        switch imageResult {
        case .success(let data):
            let posterImage = UIImage(data: data) ?? UIImage()
            let movieDetail = generateMovieDetail(with: movieInformation, movieCertification, posterImage)
            ImageCacheManager.shared.store(image: posterImage, forResourceKey: cacheKey, in: .disk)
            ImageCacheManager.shared.store(image: posterImage, forResourceKey: cacheKey, in: .memory)
            return movieDetail
        case .failure(let error):
            print(error)
            return nil
        }
    }

    private func fetchMovieCredits() {
        Task {
            do {
                guard let movieID = movie.ID else { return }

                var sortedCredits = try await generateSortedCredits(with: movieID)
                for (index, actor) in sortedCredits.prefix(16).enumerated() {
                    guard let actor else { return }
                    let actorName = actor.name
                    let characterName = actor.characterName
                    let resoureKey = MovieImage.profile(ID: actor.ID).resourceKey
                    let imageProfilePath = actor.profilePath ?? ""

                    if ImageCacheManager.shared.isCached(resourceKey: resoureKey) {
                        let cachedImage = ImageCacheManager.shared.value(forResoureceKey: resoureKey)
                        movieCredits[index].profileImage = cachedImage
                    } else {
                        try await setMovieCredits(profilePath: imageProfilePath, with: resoureKey, index: index)
                    }
                    movieCredits[index].name = actorName
                    movieCredits[index].characterName = characterName
                }
            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name.detailModelDidFetchCreditData,
                object: nil
            )
        }
    }

    private func generateSortedCredits(with movieID: Int) async throws -> [Cast?] {
        let movieCreditsEndPoint = MovieCreditsAPIEndPoint(movieCode: movieID)
        let decodedData = try await movieNetworkAPIManager.fetchData(
            to: MovieCreditsDTO.self,
            endPoint: movieCreditsEndPoint
        )
        guard let credits = decodedData as? MovieCreditsDTO else { return [] }
        let sortedCredits = credits.cast.sorted { return $0.popularity > $1.popularity }

        return sortedCredits
    }

    private func setMovieCredits(profilePath: String, with cacheKey: String, index: Int) async throws {
        let imageProfilePathEndPoint = MovieImageAPIEndPoint(imageURL: profilePath)
        let actorImageResult = try await movieNetworkDispatcher.performRequest(imageProfilePathEndPoint.urlRequest)

        switch actorImageResult {
        case .success(let data):
            guard let profileImage = UIImage(data: data) else { return }
            movieCredits[index].profileImage = profileImage
            ImageCacheManager.shared.store(image: profileImage, forResourceKey: cacheKey, in: .disk)
            ImageCacheManager.shared.store(image: profileImage, forResourceKey: cacheKey, in: .disk)
        case .failure:
            movieCredits[index].profileImage = UIImage(systemName: "person.fill")?
                .withTintColor(.gray)
                .withRenderingMode(.alwaysOriginal)
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
