//
//  Movie.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import UIKit

protocol ItemIdenfiable {

}
struct Movie: ItemIdenfiable {

    var ID: Int?
    var title: String
    let releaseDate: Date?
    var posterImage: UIImage?

    init(
        id: Int? = nil,
        title: String,
        releaseDate: Date? = nil,
        posterImage: UIImage? = nil
    ) {
        self.ID = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterImage = posterImage
    }
//
//    static func == (lhs: Movie, rhs: Movie) -> Bool {
//        return lhs.id == rhs.id
//    }

    static let skeletonModels: [Movie] = [
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage"))
    ]

}
