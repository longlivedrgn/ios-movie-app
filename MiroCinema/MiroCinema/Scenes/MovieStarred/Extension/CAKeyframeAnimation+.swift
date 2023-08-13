//
//  CAKeyframeAnimation+.swift
//  MiroCinema
//
//  Created by Miro on 2023/08/13.
//

import UIKit

extension CAKeyframeAnimation {

    static let wobble = {
        let wobbleAniamation = CAKeyframeAnimation(keyPath: "transform.rotation")
        wobbleAniamation.values = [0.0, -0.025, 0.0, 0.025, 0.0]
        wobbleAniamation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        wobbleAniamation.repeatCount = Float.greatestFiniteMagnitude

        return wobbleAniamation
    }()

}
