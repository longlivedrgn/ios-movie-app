//
//  MovieGenresFooterView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

class MovieGenresFooterView: UICollectionReusableView {
    
    private lazy var viewMoreButton: ViewMoreButton = {
        let button = ViewMoreButton()
        button.addTarget(self, action: #selector(moreButtonDidTapped), for: .touchUpInside)

        return button
    }()

    weak var delegate: MovieGenresFooterViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(viewMoreButton)

        viewMoreButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func moreButtonDidTapped(_ sender: UIButton) {
        delegate?.movieGenresFooterView(self, didButtonTapped: sender)
    }

}
