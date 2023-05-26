//
//  ViewMoreButton.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/23.
//

import UIKit

class ViewMoreButton: UIButton {

    var isTapped = false
    var buttonTitleSymbol: UIImage?
    var buttonTitle = NSMutableAttributedString()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAttributes() {
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        setButtonTitle()
    }

    func setButtonTitle() {
        switch isTapped {
        case true:
            buttonTitleSymbol = UIImage(systemName: "chevron.up")?.withTintColor(.white)
            buttonTitle = NSMutableAttributedString(string: "닫기 ")
        case false:
            buttonTitleSymbol = UIImage(systemName: "chevron.down")?.withTintColor(.white)
            buttonTitle = NSMutableAttributedString(string: "더보기 ")
        }
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = buttonTitleSymbol
        let symbolString = NSAttributedString(attachment: symbolAttachment)
        let buttonTitleColor = UIColor.white
        buttonTitle.append(symbolString)
        buttonTitle.addAttribute(
            .foregroundColor,
            value: buttonTitleColor,
            range: NSRange(location: 0, length: buttonTitle.length)
        )
        setAttributedTitle(buttonTitle, for: .normal)
    }

}
