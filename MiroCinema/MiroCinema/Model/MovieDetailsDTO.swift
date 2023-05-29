//
//  MovieDetailsDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

struct MovieDetailsDTO: Decodable {

    let originalTitle: String
    let koreanTitle: String
    let releaseDate: String
    let productionCountries: [ProductionCountry]
    let genres: [MovieKind]
    let runTime: Int
    let tagLine: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case koreanTitle = "title"
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case genres
        case runTime = "runtime"
        case tagLine = "tagline"
        case overview
        case posterPath = "poster_path"
    }

}

struct ProductionCountry: Decodable {

    let name: String

}

struct MovieKind: Decodable {

    let name: String

}
