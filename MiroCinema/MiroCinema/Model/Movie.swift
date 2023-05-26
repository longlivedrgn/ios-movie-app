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

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
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

struct MovieGenre: Hashable {

    let id = UUID()
    var backDropImage: UIImage?
    var genreTitle: String?

    init(backDropImage: UIImage? = nil, genreTitle: String? = nil) {
        self.backDropImage = backDropImage
        self.genreTitle = genreTitle
    }

    static let skeletonModels: [MovieGenre] = [
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        MovieGenre(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
    ]

}
