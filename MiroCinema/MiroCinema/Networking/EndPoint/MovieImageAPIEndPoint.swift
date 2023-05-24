//
//  MoviePosterImageAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation


struct MovieImageAPIEndPoint: MovieAPIEndPoint {

    let imageURL: String

    init(imageURL: String) {
        self.imageURL = imageURL
    }

    private enum URLConstants {
        static let baseURL = "https://image.tmdb.org"
        static let URLPath = "/t/p/original"
    }

    var endPoint: EndPoint {
        return EndPoint(
            baseURL: URLConstants.baseURL,
            path: URLConstants.URLPath + imageURL
            )
    }

    func makeQueryItems() -> [URLQueryItem]? {
        return nil
    }

}
