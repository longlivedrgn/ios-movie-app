//
//  MovieCertificationDTO.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/26.
//

import Foundation

struct MovieCertificationDTO: Decodable {

    let certifications: [Certification]

    enum CodingKeys: String, CodingKey {
        case certifications = "results"
    }

}

struct Certification: Decodable {
    let countryCode: String
    let information: [Information]

    enum CodingKeys: String, CodingKey {
        case countryCode = "iso3166_1"
        case information = "release_dates"
    }

}

struct Information: Decodable {

    let certificationRate: String

    enum CodingKeys: String, CodingKey {
        case certificationRate = "certification"
    }

}
