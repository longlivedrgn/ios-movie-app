//
//  MovieCertificationAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import Foundation

struct MovieCertificationAPIEndPoint: TMDBAPIEndPoint {

    let movieCode: String

    init(movieCode: Int) {
        self.movieCode = String(movieCode)
    }

    private enum URLConstants {
        static let baseURL = "https://api.themoviedb.org"
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/release_dates"
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
        return nil
    }

}
