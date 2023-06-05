//
//  MovieGenre.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/30.
//

import UIKit

struct MovieGenre: Hashable {

    let id = UUID()
    var backDropImage: UIImage?
    var genreTitle: String?
    var movies: MoviesDTO?

    init(backDropImage: UIImage? = nil, genreTitle: String? = nil, movies: MoviesDTO? = nil) {
        self.backDropImage = backDropImage
        self.genreTitle = genreTitle
        self.movies = movies
    }

    static func == (lhs: MovieGenre, rhs: MovieGenre) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
