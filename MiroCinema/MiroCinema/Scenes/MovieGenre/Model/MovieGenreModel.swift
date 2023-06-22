//
//  MovieGenreController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/29.
//

import UIKit

final class MovieGenreModel {

    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    private var movieDTOs: [MovieDTO]?
    var movies: [Movie] = []

    init(movies: [MovieDTO]?) {
        self.movieDTOs = movies
        fetchMovieData()
    }

    private func fetchMovieData() {
        Task {
            do {
                guard let movieDTOs else { return }
                for movieDTO in movieDTOs {
                    let movieTitle = movieDTO.koreanTitle
                    let movieID = movieDTO.ID
                    let resourceKey = MovieImage.background(ID: movieID).resourceKey
                    guard let backDropImagePath = movieDTO.backDropImagePath else { return }

                    if ImageCacheManager.shared.isCached(resourceKey: resourceKey) {
                        let cachedImage = ImageCacheManager.shared.value(forResoureceKey: resourceKey)
                        let movie = Movie(id: movieID, title: movieTitle, posterImage: cachedImage)
                        movies.append(movie)
                    } else {
                        let endPoint = MovieImageAPIEndPoint(imageURL: backDropImagePath)
                        let imageResult = try await movieNetworkDispatcher.performRequest(endPoint.urlRequest)
                        switch imageResult {
                        case .success(let data):
                            guard let backDropImage = UIImage(data: data) else { return }
                            ImageCacheManager.shared.store(image: backDropImage, forResourceKey: resourceKey, in: .memory)
                            let movie = Movie(id: movieID, title: movieTitle, posterImage: backDropImage)
                            movies.append(movie)
                        case .failure(let error):
                            print(error)
                        }
                    }
                    NotificationCenter.default.post(
                        name: NSNotification.Name.genreModelDidFetchData,
                        object: nil
                    )
                }
            } catch {
                print(error)
            }
        }

    }


}
