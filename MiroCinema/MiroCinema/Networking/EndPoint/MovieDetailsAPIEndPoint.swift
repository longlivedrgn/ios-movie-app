//
//  MovieDetailsAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation

struct MovieDetailsAPIEndPoint: TMDBAPIEndPoint {

    let movieCode: String

    init(movieCode: Int) {
        self.movieCode = String(movieCode)
    }

    private enum URLConstants {
        static let baseURL = "https://api.themoviedb.org"
        static let URLPath = "/3/movie/"
    }

    var endPoint: EndPoint {
        return EndPoint(
            baseURL: URLConstants.baseURL,
            path: URLConstants.URLPath + movieCode,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
            )
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")

        return [languageQueryItem]
    }

}
