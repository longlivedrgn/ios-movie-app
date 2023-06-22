//
//  MovieCreditsDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import Foundation

struct MovieCreditsDTO: Codable {

    let cast: [Cast]
    let crew: [Cast]

}

struct Cast: Codable {

    let ID: Int
    let name: String
    let profilePath: String?
    let characterName: String?
    let department: String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name
        case profilePath = "profile_path"
        case characterName = "character"
        case department = "known_for_department"
        case popularity
    }

}
