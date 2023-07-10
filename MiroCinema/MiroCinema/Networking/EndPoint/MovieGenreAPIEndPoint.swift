//
//  MovieGenreAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct MovieGenreAPIEndPoint: TMDBAPIEndPointable {

    let genre: Genre
    var URLPath: String = "/3/discover/movie"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders())
    }

    init(genre: Genre) {
        self.genre = genre
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        let pageNumberQueryItem = URLQueryItem(name: "sort_by", value: "revenue.desc")
        let genreCodeQueryItem = URLQueryItem(name: "with_genres", value: "\(genre.rawValue)")

        return [languageQueryItem, pageNumberQueryItem, genreCodeQueryItem]
    }

}

extension MovieGenreAPIEndPoint {

    static let allEndPoints = [
        MovieGenreAPIEndPoint(genre: .action),
        MovieGenreAPIEndPoint(genre: .documentary),
        MovieGenreAPIEndPoint(genre: .animation),
        MovieGenreAPIEndPoint(genre: .comedy),
        MovieGenreAPIEndPoint(genre: .history),
        MovieGenreAPIEndPoint(genre: .romance),
        MovieGenreAPIEndPoint(genre: .fantasy),
        MovieGenreAPIEndPoint(genre: .drama),
        MovieGenreAPIEndPoint(genre: .family),
        MovieGenreAPIEndPoint(genre: .western),
        MovieGenreAPIEndPoint(genre: .war),
        MovieGenreAPIEndPoint(genre: .mystery)
    ]

}
