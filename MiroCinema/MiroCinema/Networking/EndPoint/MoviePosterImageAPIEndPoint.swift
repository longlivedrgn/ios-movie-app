//
//  MoviePosterImageAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation


struct MoviePosterImageAPIEndPoint: APIEndpoint {

    let posterURL: String

    init(posterURL: String) {
        self.posterURL = posterURL
    }

    private enum URLConstants {
        static let baseURL = "https://image.tmdb.org"
        static let URLPath = "/t/p/original"
    }

    var endPoint: EndPoint {
        return EndPoint(
            baseURL: URLConstants.baseURL,
            path: URLConstants.URLPath + posterURL
            )
    }

    func makeQueryItems() -> [URLQueryItem]? {
        return nil
    }

    func makeHeaders() -> [String : String]? {
        return nil
    }

}
