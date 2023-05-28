//
//  MovieDetail.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//
import UIKit

struct MovieDetail {

    let certificationRate: String
    let koreanTitle: String
    let originalTitle: String
    let releaseDate: String
    let countries: [ProductionCountry]
    let genres: [MovieKind]
    let runtime: Int
    let tagLine: String
    let overview: String

}
