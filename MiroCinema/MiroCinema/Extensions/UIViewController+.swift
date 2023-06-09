//
//  UIViewController+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

extension UIViewController {

    func configureBackButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backBarButton.tintColor = .white
        navigationItem.backBarButtonItem = backBarButton
    }
    
}
