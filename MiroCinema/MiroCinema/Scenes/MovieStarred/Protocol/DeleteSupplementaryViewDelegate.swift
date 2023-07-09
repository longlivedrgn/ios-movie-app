//
//  DeleteSupplementaryViewDelegate.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/07/07.
//

import UIKit

protocol DeleteSupplementaryViewDelegate: AnyObject {

    func deleteSupplementaryView(
        _ deleteSupplementaryView: DeleteSupplementaryView,
        didButtonTapped sender: UIButton
    )
}
