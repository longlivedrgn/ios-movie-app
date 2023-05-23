//
//  MovieDetailCreditCollectionViewCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailCreditCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: MovieDetailCreditCollectionViewCell.self)

    private let actorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Monday")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    private let actorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "크리스 프렛"
        label.textColor = .systemBackground
        label.textAlignment = .center

        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "감독"
        label.textColor = .lightGray
        label.textAlignment = .center

        return label
    }()

    private lazy var creditTextVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actorNameLabel, roleLabel])
        stackView.axis = .vertical

        return stackView
    }()

    private lazy var creditHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actorImageView, creditTextVerticalStackView])
        stackView.axis = .horizontal

        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(creditHorizontalStackView)
        creditHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
