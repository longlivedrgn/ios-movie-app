//
//  DeleteSupplementaryView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/07/06.
//

import UIKit

class DeleteSupplementaryView: UICollectionReusableView {

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        return button
    }()

    weak var delegate: DeleteSupplementaryViewDelegate?

    var movie: Movie?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureView() {
        addSubview(minusButton)
        minusButton.addTarget(self, action: #selector(minusButtonDidTapped), for: .touchUpInside)
        minusButton.tintColor = .gray
        minusButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc private func minusButtonDidTapped() {
        delegate?.deleteSupplementaryView(self, didButtonTapped: minusButton)
    }

}
