//
//  MovieDetailFirstSectionViewDelegate.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//

import UIKit

protocol MovieDetailFirstSectionViewDelegate: AnyObject {

    func movieDetailFirstSectionView(
        _ movieDetailFirstSectionView: MovieDetailFirstSectionView,
        didButtonTapped sender: UIButton
    )

}
