//
//  MovieGenresFooterViewDelegate.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//
import UIKit

protocol MovieGenresFooterViewDelegate: AnyObject {

    func movieGenresFooterView(
        _ movieGenresFooterView: MovieGenresFooterView,
        didButtonTapped sender: UIButton
    )

}
