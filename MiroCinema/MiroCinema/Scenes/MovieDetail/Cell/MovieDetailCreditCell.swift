//
//  MovieDetailCreditCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailCreditCell: UICollectionViewCell {

    private let actorImageView: CircleImageView = {
        let imageView = CircleImageView()
        imageView.image = UIImage(systemName: "grayImage")
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let actorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    private lazy var creditTextVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actorNameLabel, roleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally

        return stackView
    }()

    private lazy var creditHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [actorImageView, creditTextVerticalStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with credit: MovieCredit) {
        actorImageView.image = credit.profileImage
        actorNameLabel.text = credit.name
        roleLabel.text = credit.characterName
    }

    private func configureViews() {
        addSubview(creditHorizontalStackView)

        creditHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        creditTextVerticalStackView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.65)
        }
        actorImageView.snp.makeConstraints {
            $0.height.equalTo(creditTextVerticalStackView.snp.height)
            $0.width.equalTo(actorImageView.snp.height)
        }
    }

}
