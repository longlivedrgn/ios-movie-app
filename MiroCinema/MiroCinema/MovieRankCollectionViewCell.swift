//
//  MovieRankCollectionViewCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieRankCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: MovieRankCollectionViewCell.self)

    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .gray

        return containerView
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Dream")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "드림"
        label.textAlignment = .left
        label.backgroundColor = .darkGray

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
        self.backgroundColor = .brown
        addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(movieNameLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.6),

            movieNameLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

    }

}
