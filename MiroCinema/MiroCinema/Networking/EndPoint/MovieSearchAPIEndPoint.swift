//
//  MovieSearchAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import Foundation

struct MovieSearchAPIEndPoint: TMDBAPIEndPointable {

    let searchQuery: String

    init(input: String) {
        self.searchQuery = input
    }

    var URLPath: String = "/3/search/movie"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders())
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        let pageNumberQueryItem = URLQueryItem(name: "page", value: "1")
        let searchQueryItem = URLQueryItem(name: "query", value: searchQuery)

        return [languageQueryItem, pageNumberQueryItem, searchQueryItem]
    }

}
