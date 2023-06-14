//
//  Movie.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import UIKit

struct Movie: Hashable {

    var ID: Int?
    var title: String
    let id = UUID()
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
