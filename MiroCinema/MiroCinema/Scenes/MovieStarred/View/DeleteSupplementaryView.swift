//
//  DeleteSupplementaryView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/07/06.
//

import UIKit

class DeleteSupplementaryView: UICollectionReusableView {

    private let minusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus.circle.fill")
        imageView.tintColor = .gray

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureView() {
        addSubview(minusImageView)

        minusImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
