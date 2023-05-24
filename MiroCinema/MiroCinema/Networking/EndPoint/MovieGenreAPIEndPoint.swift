//
//  MovieGenreAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct MovieGenreAPIEndPoint: MovieAPIEndPoint {

    let genre: Genre

    init(genre: Genre) {
        self.genre = genre
    }

    private enum URLConstants {
        static let baseURL = "https://api.themoviedb.org"
        static let URLPath = "/3/discover/movie"
    }

    var endPoint: EndPoint {
        return EndPoint(
            baseURL: URLConstants.baseURL,
            path: URLConstants.URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders())
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        let pageNumberQueryItem = URLQueryItem(name: "sort_by", value: "revenue.desc")
        let genreCodeQueryItem = URLQueryItem(name: "with_genres", value: "\(genre.rawValue)")


        return [languageQueryItem, pageNumberQueryItem, genreCodeQueryItem]
    }

}
