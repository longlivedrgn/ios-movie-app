//
//  MovieDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import Foundation

struct MovieDTO: Decodable, Hashable {

    let ID: Int
    let originalTitle: String
    let posterPath: String?
    let backDropImagePath: String?
    let koreanTitle: String
    let releaseDate: String
    let id = UUID()

    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backDropImagePath = "backdrop_path"
        case koreanTitle = "title"
        case releaseDate = "release_date"
    }

}
