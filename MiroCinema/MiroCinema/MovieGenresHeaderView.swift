//
//  MovieGenresCollectionReusableView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieGenresHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieGenresHeaderView.self)

    private let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "장르별 영화"
        label.font = label.font.withSize(18)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(movieGenresLabel)
    }

}
