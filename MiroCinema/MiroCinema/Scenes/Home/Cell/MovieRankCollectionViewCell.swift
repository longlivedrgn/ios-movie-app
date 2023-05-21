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

        return containerView
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Dream")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = "존윅 4"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .lightGray

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        movieNameLabel.text = movie.title
        movieImageView.image = movie.posterImage
    }

    private func configure() {
        addSubview(containerView)
        containerView.addSubview(movieImageView)
        containerView.addSubview(movieNameLabel)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        movieImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(containerView.snp.width).multipliedBy(1.6)
        }

        movieNameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(movieImageView.snp.bottom)
        }
    }

}
