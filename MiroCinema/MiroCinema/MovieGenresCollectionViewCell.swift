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
        containerView.translatesAutoresizingMaskIntoConstraints = false

        return containerView
    }()

    private let movieGenreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Monday")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    let movieGenreNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "먼데이"
        label.textColor = .systemBackground
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
        containerView.addSubview(movieGenreImageView)
        containerView.addSubview(movieGenreNameLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            movieGenreImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            movieGenreImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieGenreImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieGenreImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.617),

            movieGenreNameLabel.topAnchor.constraint(equalTo: movieGenreImageView.bottomAnchor),
            movieGenreNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            movieGenreNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            movieGenreNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }



}
