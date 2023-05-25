//
//  MovieRankHeaderViewDelegate.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//

import UIKit

protocol MovieRankHeaderViewDelegate: AnyObject {

    func movieRankHeaderView(
        _ movieRankHeaderView: MovieRankHeaderView,
        didButtonTapped sender: UIButton
    )

}
