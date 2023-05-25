//
//  Movie.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/21.
//

import UIKit

struct Movie: Hashable {

    var ID: Int?
    var title: String?
    let id = UUID()
    var posterImage: UIImage?
    var backDropImage: UIImage?
    var genreTitle: String?

    init(
        id: Int? = nil,
        title: String? = nil,
        posterImage: UIImage? = nil,
        backDropImage: UIImage? = nil,
        genreTitle: String? = nil
    ) {
        self.ID = id
        self.title = title
        self.posterImage = posterImage
        self.backDropImage = backDropImage
        self.genreTitle = genreTitle
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

}
