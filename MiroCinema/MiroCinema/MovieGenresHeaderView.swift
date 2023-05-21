//
//  MovieGenresCollectionReusableView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieGenresHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieGenresHeaderView.self)

    private let containerView: UIView = {
        let view = UIView()

        return view
    }()

    private let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.text = "장르별 영화"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .systemBackground

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
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
