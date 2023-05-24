//
//  CircleImageView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/24.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = min(frame.width/2 , frame.height/2)
        clipsToBounds = true
    }

}
