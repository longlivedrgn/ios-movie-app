//
//  MoviePosterImageAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation


struct MovieImageAPIEndPoint: TMDBAPIEndPointable {

    let imageURL: String
    var URLPath: String = "/t/p/original"
    var baseURL: String = "https://image.tmdb.org"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath + imageURL
            )
    }

    init(imageURL: String) {
        self.imageURL = imageURL
    }

    func makeQueryItems() -> [URLQueryItem]? {
        return nil
    }

}
