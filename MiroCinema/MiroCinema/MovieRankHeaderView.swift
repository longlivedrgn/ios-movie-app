//
//  MovieRankHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieRankHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieRankHeaderView.self)

    private let sortedByOpenDateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.setTitle("영화 개봉순", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 14)

        return button
    }()

    private let sortedByReservationRateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .darkGray
        button.setTitle("예매율순", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .systemFont(ofSize: 14)

        return button
    }()

    private lazy var movieRankHorizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [sortedByOpenDateButton, sortedByReservationRateButton]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        addSubViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(movieRankHorizontalStackView)
        movieRankHorizontalStackView.addSubview(sortedByOpenDateButton)
        movieRankHorizontalStackView.addSubview(sortedByReservationRateButton)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            movieRankHorizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieRankHorizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            movieRankHorizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
