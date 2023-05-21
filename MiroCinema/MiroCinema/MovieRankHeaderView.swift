//
//  MovieRankHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieRankHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieRankHeaderView.self)

    private let containerView: UIView = {
        let view = UIView()

        return view
    }()


    private let sortedByOpenDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("영화 개봉순", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = UIColor(red: 0.902, green: 0.286, blue: 0.502, alpha: 1)

        return button
    }()

    private let sortedByReservationRateButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매율순", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 1
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.gray.cgColor

        return button
    }()

    private lazy var movieRankHorizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [sortedByOpenDateButton, sortedByReservationRateButton]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillProportionally

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(containerView)
        containerView.addSubview(movieRankHorizontalStackView)
        movieRankHorizontalStackView.addSubview(sortedByOpenDateButton)
        movieRankHorizontalStackView.addSubview(sortedByReservationRateButton)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.top.bottom.equalToSuperview()
        }

        movieRankHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
