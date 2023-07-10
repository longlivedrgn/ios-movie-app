//
//  MovieDetailsAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation

struct MovieDetailsAPIEndPoint: TMDBAPIEndPointable {

    let movieCode: String
    var URLPath: String = "/3/movie/"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath + movieCode,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
            )
    }

    init(movieCode: Int) {
        self.movieCode = String(movieCode)
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")

        return [languageQueryItem]
    }

}
