//
//  MovieCredit.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

struct MovieCredit {

    let name: String
    let department: String?
    let profileImage: UIImage?

    init(name: String, department: String?, profileImage: UIImage?) {
        self.name = name
        self.department = department
        self.profileImage = profileImage
    }

}
