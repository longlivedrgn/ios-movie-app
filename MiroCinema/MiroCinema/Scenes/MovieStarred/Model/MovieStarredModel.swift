//
//  MovieStarredModel.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/27.
//

import Foundation

final class MovieStarredModel {

    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    var movies = [Movie]()

    init() {
        fetchMovies()
    }

    private func fetchMovies() {
        let starredMovieData = PersistenceManager.shared.fetchAllData()
        for movieData in starredMovieData {
            let movieTitle = movieData.title
            let movieID = Int(movieData.id)
            let posterImageKey = MovieImage.poster(ID: movieID).resourceKey
            let cachedImage = ImageCacheManager.shared.value(forResoureceKey: posterImageKey)
            
            movies.append(Movie(id: movieID, title: movieTitle, posterImage: cachedImage))
        }
        print(movies)
    }

}
