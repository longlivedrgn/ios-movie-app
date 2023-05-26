//
//  MovieCredit.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

struct MovieCredit {

    var name: String
    var department: String?
    var profileImage: UIImage?

    init(name: String, department: String?, profileImage: UIImage?) {
        self.name = name
        self.department = department
        self.profileImage = profileImage
    }

    static var skeletonModels = [MovieCredit](
        repeating: MovieCredit(name: "-", department: "-", profileImage: UIImage(named: "grayImage")),
        count: 16
    )

}
