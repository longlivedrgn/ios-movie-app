//
//  Movie.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct Movie: Decodable {

    let ID: Int
    let originalTitle: String
    let posterPath: String
    let koreanTitle: String

    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case koreanTitle = "title"
    }

}
