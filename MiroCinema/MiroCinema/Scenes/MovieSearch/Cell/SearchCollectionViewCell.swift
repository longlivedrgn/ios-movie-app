//
//  SearchCollectionViewCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .gray

        return containerView
    }()

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.up.fill")
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red

        return imageView
    }()

    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.backgroundColor = .green

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        movieNameLabel.text = movie.title
        movieImageView.image = movie.posterImage
    }

    private func configureViews() {
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
