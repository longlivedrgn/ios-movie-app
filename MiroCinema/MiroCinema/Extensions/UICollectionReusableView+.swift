//
//  UICollectionReusableView+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/08.
//

import UIKit

extension UICollectionReusableView {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

}
