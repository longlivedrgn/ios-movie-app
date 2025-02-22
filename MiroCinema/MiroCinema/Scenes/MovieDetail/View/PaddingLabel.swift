//
//  PaddingLabel.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class PaddingLabel: UILabel {

    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }

}
