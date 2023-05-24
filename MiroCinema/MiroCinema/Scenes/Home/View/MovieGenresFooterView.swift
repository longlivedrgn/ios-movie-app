//
//  MovieGenresFooterView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

class MovieGenresFooterView: UICollectionReusableView {
    
    static let identifer = String(describing: MovieGenresFooterView.self)

    private let viewMoreButton: ViewMoreButton = {
        let viewMoreButton = ViewMoreButton()

        return viewMoreButton
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
        addSubview(viewMoreButton)
    }

    private func layoutUI() {
        viewMoreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
