//
//  MovieSearchModel.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

final class MovieSearchModel {

    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    var searchEndPoint = MovieSearchAPIEndPoint(input: "-") {
        didSet {
            fetchMoviesData()
        }
    }

    var movies = [Movie]()

    private func fetchMoviesData() {
        Task {
            do {
                guard let moviesDTO = try await movieNetworkManager.fetchData(
                    to: MoviesDTO.self,
                    endPoint: searchEndPoint
                ) as? MoviesDTO else { return }
                let movieList = moviesDTO.movies

                for movie in movieList {
                    let title = movie.koreanTitle
                    let id = movie.ID
                    guard let posterPath = movie.posterPath else { return }

                    let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
                    let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        let movie = Movie(id: id, title: title, posterImage: posterImage)
                        movies.append(movie)
                    case .failure(let error):
                        print(error)
                    }
                    NotificationCenter.default.post(
                        name: NSNotification.Name.searchModelDidFetchData,
                        object: nil
                    )
                }
            }
            catch {
                print(error)
            }
        }
    }
}
