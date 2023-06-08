//
//  MovieDetailHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/23.
//

import UIKit

class MovieDetailHeaderView: UICollectionReusableView {

    private let headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "감독 및 등장인물"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        addSubview(headerTextLabel)

        headerTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
