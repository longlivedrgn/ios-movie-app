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
        print(PersistenceManager.shared.fetchAllMovieIDs())
    }

}
