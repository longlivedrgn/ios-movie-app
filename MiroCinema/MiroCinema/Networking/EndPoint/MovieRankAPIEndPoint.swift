//
//  MovieRankAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct MovieRankAPIEndPoint: MovieAPIEndPoint {

    private enum URLConstants {
        static let baseURL = "https://api.themoviedb.org"
        static let URLPath = "/3/movie/popular"
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
        let pageNumberQueryItem = URLQueryItem(name: "page", value: "1")

        return [languageQueryItem, pageNumberQueryItem]
    }

}
