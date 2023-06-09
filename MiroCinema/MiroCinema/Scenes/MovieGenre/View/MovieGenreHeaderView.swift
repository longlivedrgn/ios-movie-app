//
//  MovieGenreHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/29.
//

import UIKit

class MovieGenreHeaderView: UICollectionReusableView {

    private let containerView: UIView = {
        let view = UIView()

        return view
    }()

    private let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.text = "역대 흥행 순"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(containerView)
        containerView.addSubview(movieGenresLabel)

        containerView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }

        movieGenresLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }

}
