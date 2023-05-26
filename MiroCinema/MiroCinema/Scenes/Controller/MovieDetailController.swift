//
//  MovieDetailController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import UIKit

final class MovieDetailController {

    let movie: Movie
    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()
    var movieDetail: MovieDetailsDTO?
    var movieCredits = MovieCredit.skeletonModels

    init(movie: Movie) {
        self.movie = movie
        fetchMovieDetails()
        fetchMovieCredits()
    }

    private func fetchMovieDetails() {
        guard let movieID = movie.ID else { return }
        let movieDetailEndPoint = MovieDetailsAPIEndPoint(movieCode: movieID)
        Task {
            do {
                let decodedData = try await movieNetworkAPIManager.fetchData(
                    to: MovieDetailsDTO.self,
                    endPoint: movieDetailEndPoint
                )
                guard let movieInformation = decodedData as? MovieDetailsDTO else { return }
                movieDetail = movieInformation
            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name("MovieDetailControllerDidFetchData"),
                object: nil
            )
        }
    }

    private func fetchMovieCredits() {
        guard let movieID = movie.ID else { return }
        let movieCreditsEndPoint = MovieCreditsAPIEndPoint(movieCode: movieID)
        Task {
            do {
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
                    let imageProfilePathEndPoint = MovieImageAPIEndPoint(imageURL: imageProfilePath)
                    let actorImageResult = try await movieNetworkDispatcher.performRequest(imageProfilePathEndPoint.urlRequest)

                    movieCredits[index].name = actorName
                    movieCredits[index].characterName = characterName

                    switch actorImageResult {
                    case .success(let data):
                        guard let profileImage = UIImage(data: data) else { return }
                        movieCredits[index].profileImage = profileImage
                    case .failure:
                        movieCredits[index].profileImage = UIImage(systemName: "x.square.fill")?
                            .withTintColor(.gray)
                            .withRenderingMode(.alwaysOriginal)
                    }
                }

            } catch {
                print(error)
            }
            NotificationCenter.default.post(
                name: NSNotification.Name("MovieDetailControllerDidFetchData"),
                object: nil
            )
        }
    }
}
