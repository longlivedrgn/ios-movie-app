//
//  MovieGenreListCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class MovieGenreListCell: UICollectionViewListCell {

    static let identifier = String(describing: MovieGenreListCell.self)

    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        return imageView
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white

        return label
    }()

    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        backDropImageView.image = movie.posterImage
        movieTitleLabel.text = movie.title
    }

    private func configureViews() {
        contentView.backgroundColor = .black
        addSubview(backDropImageView)
        addSubview(movieTitleLabel)
        addSubview(symbolImageView)

        backDropImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(backDropImageView.snp.height).multipliedBy(1.5)
        }

        movieTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backDropImageView.snp.centerY)
            $0.leading.equalTo(backDropImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(symbolImageView.snp.leading).offset(-10)
        }

        symbolImageView.snp.makeConstraints {
            $0.centerY.equalTo(backDropImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(30)
            $0.height.equalTo(symbolImageView.snp.width)
        }
    }

}
