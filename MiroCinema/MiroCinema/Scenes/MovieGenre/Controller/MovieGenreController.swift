//
//  MovieGenreController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/29.
//

import Foundation

final class MovieGenreController {

    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    var genreMovies: [MovieDTO]?

    init(movies: [MovieDTO]?) {
        self.genreMovies = movies
        fetchMovieData()
    }

    private func fetchMovieData() {
        
    }


}
