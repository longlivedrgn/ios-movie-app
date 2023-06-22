//
//  MovieImage.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/22.
//

import Foundation

enum MovieImage {

    case poster(ID: Int)
    case background(ID: Int)
    case profile(ID: Int)

    var resourceKey: String {
        switch self {
        case .poster(let ID):
            return "\(ID)poster"
        case .background(let ID):
            return "\(ID)background"
        case .profile(let ID):
            return "\(ID)profile"
        }
    }

}
