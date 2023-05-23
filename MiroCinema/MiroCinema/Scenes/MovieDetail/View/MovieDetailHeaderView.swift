//
//  MovieDetailHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/23.
//

import UIKit

class MovieDetailHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieDetailHeaderView.self)

    private let headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "감독 및 등장인물"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(headerTextLabel)
    }

    private func layoutUI() {
        headerTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
