//
//  MovieRankDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

struct Movies: Decodable {

    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

}
