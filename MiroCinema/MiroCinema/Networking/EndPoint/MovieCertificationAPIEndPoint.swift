//
//  MovieCertificationAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import Foundation

struct MovieCertificationAPIEndPoint: TMDBAPIEndPointable {

    private enum URLConstants {
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/release_dates"
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
        return nil
    }

}
