//
//  GenreListCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class GenreListCell: UICollectionViewListCell {

    static let identifier = String(describing: GenreListCell.self)

    private let backDropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowshape.right.fill")

        return imageView
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"

        return label
    }()

    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowshape.right.fill")

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
        addSubview(backDropImageView)
        addSubview(movieTitleLabel)
        addSubview(symbolImageView)

        backDropImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(self.backDropImageView.snp.height).multipliedBy(1.7)
        }

        movieTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backDropImageView.snp.centerY)
            $0.leading.equalTo(backDropImageView.snp.leading).offset(10)
        }

        symbolImageView.snp.makeConstraints {
            $0.centerY.equalTo(backDropImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(10)
        }
    }

}
