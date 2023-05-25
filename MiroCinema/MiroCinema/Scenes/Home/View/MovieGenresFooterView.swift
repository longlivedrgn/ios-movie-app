//
//  MovieGenresFooterView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

class MovieGenresFooterView: UICollectionReusableView {
    
    static let identifer = String(describing: MovieGenresFooterView.self)

    private lazy var viewMoreButton: ViewMoreButton = {
        let button = ViewMoreButton()
        button.addTarget(self, action: #selector(moreButtonDidTapped), for: .touchUpInside)

        return button
    }()

    weak var delegate: MovieGenresFooterViewDelegate?

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

    @objc private func moreButtonDidTapped(_ sender: UIButton) {
        delegate?.movieGenresFooterView(self, didButtonTapped: sender)
    }

}
