//
//  MovieGenresCollectionViewCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieGenresCollectionViewCell: UICollectionViewCell {

    private let containerView: UIView = {
        let containerView = UIView()

        return containerView
    }()

    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Monday")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    let genreNameLabel: UILabel = {
        let label = UILabel()
        label.text = "먼데이"
        label.textColor = .lightGray
        label.textAlignment = .center

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MovieGenre) {
        genreNameLabel.text = movie.genreTitle
        genreImageView.image = movie.backDropImage
    }

    private func configureViews() {
        addSubview(containerView)
        containerView.addSubview(genreNameLabel)
        containerView.addSubview(genreImageView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        genreImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(genreImageView.snp.width).multipliedBy(0.617)
        }

        genreNameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(genreImageView.snp.bottom)
        }
    }

}
