//
//  MovieCreditsAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation


import Foundation

struct MovieCreditsAPIEndPoint: TMDBAPIEndPointable {

    private enum URLConstants {
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/credits"
    }

    let movieCode: String
    var URLPath: String
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
            )
    }

    init(movieCode: Int) {
        self.movieCode = String(movieCode)
        self.URLPath = URLConstants.URLPathPrefix + self.movieCode + URLConstants.URLPathSuffix
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")

        return [languageQueryItem]
    }

}
