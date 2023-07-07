//
//  DeleteSupplementaryView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/07/06.
//

import UIKit

class DeleteSupplementaryView: UICollectionReusableView {

    private let minusLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .gray

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureView() {
        backgroundColor = .darkGray
        addSubview(minusLabel)
        minusLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        configureBorder()
    }

    private func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.clear.cgColor
    }

}
