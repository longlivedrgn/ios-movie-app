//
//  MovieAPIEndPoint.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation

protocol TMDBAPIEndPoint: APIEndpoint {

}

extension TMDBAPIEndPoint {

    func makeHeaders() -> [String : String]? {
        let authorizationHeaderKey = "Authorization"
        let authorizationHeaderValue = " Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYmJjZGYwYTBlYmU5NmYzZDc5ZTczNTEzNDA1NGM1MSIsInN1YiI6IjY0NjcyZTIzMDA2YjAxMDE0N2U5MzI2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.onD8bXrAVqUDE5hgfGXShHxEQS8LP2M9CmBnTEqZNPs"

        let acceptionHeaderKey = "accept"
        let acceptionHeaderValue = "application/json"

        return [authorizationHeaderKey: authorizationHeaderValue,
                    acceptionHeaderKey: acceptionHeaderValue]
    }

}
