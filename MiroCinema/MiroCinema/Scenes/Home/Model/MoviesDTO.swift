//
//  MoviesDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

struct MoviesDTO: Decodable {

    let movies: [MovieDTO]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

}
