//
//  Movie.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct Movie: Decodable {

    let movieID: Int
    let movieTitle: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case movieTitle = "original_title"
        case posterPath = "poster_path"
    }

}
