//
//  MovieGenreAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct MovieGenreAPIEndPoint: APIEndpoint {

    private let genreCode: Int

    init(genreCode: Int) {
        self.genreCode = genreCode
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
        let genreCodeQueryItem = URLQueryItem(name: "with_genres", value: "\(genreCode)")


        return [languageQueryItem, pageNumberQueryItem, genreCodeQueryItem]
    }

    func makeHeaders() -> [String : String]? {
        let authorizationHeaderKey = "Authorization"
        let authorizationHeaderValue = " Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYmJjZGYwYTBlYmU5NmYzZDc5ZTczNTEzNDA1NGM1MSIsInN1YiI6IjY0NjcyZTIzMDA2YjAxMDE0N2U5MzI2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.onD8bXrAVqUDE5hgfGXShHxEQS8LP2M9CmBnTEqZNPs"

        let acceptionHeaderKey = "accept"
        let acceptionHeaderValue = "application/json"

        return [authorizationHeaderKey: authorizationHeaderValue,
                    acceptionHeaderKey: acceptionHeaderValue]
    }

}
