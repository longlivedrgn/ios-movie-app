//
//  MovieHomeModel.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import UIKit

final class MovieHomeModel {

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
                // Movielist를 가져오기
                guard let movieRank = try await self.movieNetworkManager.fetchData(
                    to: MoviesDTO.self,
                    endPoint: movieRankEndPoint
                ) as? MoviesDTO else { return }
                let movieList = Array(movieRank.movies.prefix(10))
                try await convertToMovieModel(movieDTOList: movieList)

                NotificationCenter.default.post(
                    name: NSNotification.Name.homeModelDidFetchData,
                    object: nil
                )
            } catch {
                print(error)
            }
        }
    }

    private func convertToMovieModel(movieDTOList: [MovieDTO]) async throws {
        for (index, movieDTO) in movieDTOList.enumerated() {
            let title = movieDTO.koreanTitle
            let id = movieDTO.ID
            let releaseDate = movieDTO.releaseDate.convertToDate()
            let posterImageKey = MovieImage.poster(ID: id).resourceKey

            guard let posterPath = movieDTO.posterPath else { return }

            if ImageCacheManager.shared.isCached(resourceKey: posterImageKey) {
                let cachedImage = ImageCacheManager.shared.value(forResoureceKey: posterImageKey)
                let movie = Movie(id: id, title: title, releaseDate: releaseDate, posterImage: cachedImage)
                movies[index] = movie
                continue
            } else {
                try await fetchMoviePosterImage(with: posterPath, id: id, title: title, releaseDate: releaseDate, in: index)
            }
        }
    }

    private func fetchMoviePosterImage(
        with posterPath: String,
        id: Int,
        title: String,
        releaseDate: Date,
        in index: Int
    ) async throws {
        let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
        let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)
        let posterImageKey = MovieImage.poster(ID: id).resourceKey

        switch imageResult {
        case .success(let data):
            guard let posterImage = UIImage(data: data) else { return }
            let movie = Movie(id: id, title: title, releaseDate: releaseDate, posterImage: posterImage)
            movies[index] = movie
            ImageCacheManager.shared.store(image: posterImage, forResourceKey: posterImageKey, in: .disk)
            ImageCacheManager.shared.store(image: posterImage, forResourceKey: posterImageKey, in: .memory)
        case .failure(let error):
            print(error)
        }
    }

    private func fetchGenresData() {

        let allGenresEndPoints = MovieGenreAPIEndPoint.allEndPoints
        Task {
            do {
                for (index, genreEndPoint) in allGenresEndPoints.enumerated() {
                    guard let movieItems = try await movieNetworkManager.fetchData(
                        to: MoviesDTO.self,
                        endPoint: genreEndPoint
                    ) as? MoviesDTO else { return }
                    guard let bestMovie = movieItems.movies.first else { return }
                    guard let backDropImagePath = bestMovie.backDropImagePath else { return }
                    let backgroundImageKey = MovieImage.background(ID: bestMovie.ID).resourceKey
                    try await convertToMovieGenreModel(
                        with: backDropImagePath,
                        genreEndPoint: genreEndPoint,
                        movies: movieItems,
                        cacheKey: backgroundImageKey,
                        in: index
                    )
                }

                NotificationCenter.default.post(
                    name: NSNotification.Name.homeModelDidFetchData,
                    object: nil
                )
            } catch {
                print(error)
            }
        }
    }

    private func convertToMovieGenreModel(
        with backDropImagePath: String,
        genreEndPoint: MovieGenreAPIEndPoint,
        movies: MoviesDTO,
        cacheKey: String,
        in index: Int
    ) async throws {
        if ImageCacheManager.shared.isCached(resourceKey: cacheKey) {
            let cachedImage = ImageCacheManager.shared.value(forResoureceKey: cacheKey)
            let genre = MovieGenre(
                backDropImage: cachedImage,
                genreTitle: genreEndPoint.genre.description,
                movies: movies
            )
            if (0...5).contains(index){
                genres[index] = genre
            } else {
                genres.append(genre)
            }
        } else {
            try await fetchMovieBackDropImage(
                with: backDropImagePath,
                genreEndPoint: genreEndPoint,
                movies: movies,
                cacheKey: cacheKey,
                in: index
            )
        }
    }

    private func fetchMovieBackDropImage(
        with backDropImagePath: String,
        genreEndPoint: MovieGenreAPIEndPoint,
        movies: MoviesDTO,
        cacheKey: String,
        in index: Int
    ) async throws {
        let endPoint = MovieImageAPIEndPoint(imageURL: backDropImagePath)

        let imageResult = try await movieNetworkDispatcher.performRequest(endPoint.urlRequest)

        switch imageResult {
        case .success(let data):
            guard let backDropImage = UIImage(data: data) else { return }
            let genre = MovieGenre(
                backDropImage: backDropImage,
                genreTitle: genreEndPoint.genre.description,
                movies: movies
            )
            if (0...5).contains(index){
                genres[index] = genre
            } else {
                genres.append(genre)
            }
            ImageCacheManager.shared.store(image: backDropImage, forResourceKey: cacheKey, in: .disk)
            ImageCacheManager.shared.store(image: backDropImage, forResourceKey: cacheKey, in: .memory)
        case .failure(let error):
            print(error)
        }
    }
}
