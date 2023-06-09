//
//  MovieCreditsAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation


import Foundation

struct MovieCreditsAPIEndPoint: TMDBAPIEndPoint {

    let movieCode: String

    init(movieCode: Int) {
        self.movieCode = String(movieCode)
    }

    private enum URLConstants {
        static let baseURL = "https://api.themoviedb.org"
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/credits"
    }

    var endPoint: EndPoint {
        return EndPoint(
            baseURL: URLConstants.baseURL,
            path: URLConstants.URLPathPrefix + movieCode + URLConstants.URLPathSuffix,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
            )
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")

        return [languageQueryItem]
    }

}
