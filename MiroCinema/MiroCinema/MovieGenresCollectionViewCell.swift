//
//  MovieGenresCollectionViewCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieGenresCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: MovieGenresCollectionViewCell.self)

    private let containerView: UIView = {
        let containerView = UIView()

        return containerView
    }()

    private let movieGenreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Monday")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let movieGenreNameLabel: UILabel = {
        let label = UILabel()
        label.text = "먼데이"
        label.textColor = .lightGray
        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(containerView)
        containerView.addSubview(movieGenreNameLabel)
        containerView.addSubview(movieGenreImageView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        movieGenreImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(movieGenreImageView.snp.width).multipliedBy(0.617)
        }

        movieGenreNameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(movieGenreImageView.snp.bottom)
        }
    }

}
