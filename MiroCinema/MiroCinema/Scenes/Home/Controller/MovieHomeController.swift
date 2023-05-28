//
//  MovieHomeController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import UIKit

class MovieHomeController {

    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()
    var movies = Movie.skeletonModels
    var genres = MovieGenre.skeletonModels

    init() {
        fetchRankData()
        fetchGenresData()
    }

    private func fetchRankData() {
        let movieRankEndPoint = MovieRankAPIEndPoint()
        Task {
            do {
                let decodedData = try await movieNetworkManager.fetchData(
                    to: MoviesDTO.self,
                    endPoint: movieRankEndPoint
                )
                guard let movieRank = decodedData as? MoviesDTO else { return }
                let movieList = movieRank.movies.prefix(10)

                for (index, movieDTO) in movieList.enumerated() {
                    let title = movieDTO.koreanTitle
                    let id = movieDTO.ID
                    let releaseDate = movieDTO.releaseDate.convertToDate()
                    guard let posterPath = movieDTO.posterPath else { return }
                    let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
                    let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        let movie = Movie(id: id, title: title, releaseDate: releaseDate, posterImage: posterImage)
                        movies[index] = movie
                    case .failure(let error):
                        print(error)
                    }
                }
                NotificationCenter.default.post(
                    name: NSNotification.Name("MovieHomeControllerDidFetchData"),
                    object: nil
                )
            } catch {
                print(error)
            }
        }
    }

    private func fetchGenresData() {

        let allGenresEndPoints = MovieGenreAPIEndPoint.allEndPoints
        Task {
            do {
                for (index, genreEndPoint) in allGenresEndPoints.enumerated() {
                    let decodedData = try await movieNetworkManager.fetchData(
                        to: MoviesDTO.self,
                        endPoint: genreEndPoint
                    )
                    guard let movieItems = decodedData as? MoviesDTO else { return }
                    guard let bestMovie = movieItems.movies.first else { return }
                    guard let backDropImagePath = bestMovie.backDropImagePath else { return }
                    let endPoint = MovieImageAPIEndPoint(imageURL: backDropImagePath)
                    let imageResult = try await movieNetworkDispatcher.performRequest(endPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let backDropImage = UIImage(data: data) else { return }
                        let genre = MovieGenre(backDropImage: backDropImage, genreTitle: genreEndPoint.genre.description)
                        if (0...5).contains(index){
                            genres[index] = genre
                        } else {
                            genres.append(genre)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                NotificationCenter.default.post(
                    name: NSNotification.Name("MovieHomeControllerDidFetchData"),
                    object: nil
                )
            } catch {
                print(error)
            }
        }
    }

}
