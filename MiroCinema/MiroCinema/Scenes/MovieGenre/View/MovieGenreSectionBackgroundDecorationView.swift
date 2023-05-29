//
//  MovieGenreSectionBackgroundDecorationView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/29.
//

import UIKit

class MovieGenreSectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func configure() {
        backgroundColor = UIColor.black
    }

}
