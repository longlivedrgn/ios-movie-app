//
//  StarButton.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/22.
//

import UIKit

final class StarButton: UIButton {

    var isStarred = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAttributes() {
        var starButtonIcon: UIImage?
        if isStarred {
            starButtonIcon = UIImage(systemName: "star.fill")?.withTintColor(
                .yellow,
                renderingMode: .alwaysOriginal
            )
        } else {
            starButtonIcon = UIImage(systemName: "star")?.withTintColor(
                .lightGray,
                renderingMode: .alwaysOriginal
            )
        }
        self.setImage(starButtonIcon, for: .normal)
    }

    func changeStarredState() {
        isStarred.toggle()
        configureAttributes()
    }

}
