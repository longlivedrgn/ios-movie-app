//
//  RankSortButton.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//

import UIKit

class RankSortButton: UIButton {

    var sort: ButtonType?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAttributes() {
        layer.cornerRadius = 20
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

}
