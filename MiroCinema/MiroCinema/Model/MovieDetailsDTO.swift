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
    let genres: [MovieGenre]
    let runTime: Int
    let tagLine: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case koreanTitle = "title"
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case genres
        case runTime = "runtime"
        case tagLine = "tagline"
        case overview
    }

}

struct ProductionCountry: Decodable {

    let name: String

}

struct MovieGenre: Decodable {

    let name: String

}
