//
//  MovieGenre.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/30.
//

import UIKit

struct MovieGenre: ItemIdenfiable {

    var identity = UUID()
    var backDropImage: UIImage?
    var genreTitle: String?
    var movies: MoviesDTO?

    init(backDropImage: UIImage? = nil, genreTitle: String? = nil, movies: MoviesDTO? = nil) {
        self.backDropImage = backDropImage
        self.genreTitle = genreTitle
        self.movies = movies
    }

    static func == (lhs: MovieGenre, rhs: MovieGenre) -> Bool {
        return lhs.identity == rhs.identity
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
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
