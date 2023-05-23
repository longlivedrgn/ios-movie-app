//
//  ViewMoreButton.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/23.
//

import UIKit

class ViewMoreButton: UIButton {

    var isTapped: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
        let buttonTitleColor = UIColor.white
        backgroundColor = .darkGray
        layer.cornerRadius = 10
        // MARK: 여기 로직 처리 깔끔하게 하기!

        if !isTapped {
            let symbolImage = UIImage(systemName: "chevron.down")?.withTintColor(.white)
            let buttonTitle = NSMutableAttributedString(string: "더보기 ")
            let symbolAttachment = NSTextAttachment()
            symbolAttachment.image = symbolImage
            let symbolString = NSAttributedString(attachment: symbolAttachment)
            buttonTitle.append(symbolString)
            buttonTitle.addAttribute(.foregroundColor, value: buttonTitleColor, range: NSRange(location: 0, length: buttonTitle.length))
            setAttributedTitle(buttonTitle, for: .normal)
        } else {
            let symbolImage = UIImage(systemName: "chevron.down")?.withTintColor(.white)
            let buttonTitle = NSMutableAttributedString(string: "닫기 ")
            let symbolAttachment = NSTextAttachment()
            symbolAttachment.image = symbolImage
            let symbolString = NSAttributedString(attachment: symbolAttachment)
            buttonTitle.append(symbolString)
            buttonTitle.addAttribute(.foregroundColor, value: buttonTitleColor, range: NSRange(location: 0, length: buttonTitle.length))
            setAttributedTitle(buttonTitle, for: .normal)
        }


    }

}
