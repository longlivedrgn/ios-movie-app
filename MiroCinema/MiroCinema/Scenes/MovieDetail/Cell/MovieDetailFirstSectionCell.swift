//
//  MovieDetailFirstSectionCell.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/23.
//

import UIKit

class MovieDetailFirstSectionCell: UICollectionViewCell {

    static let identifier = String(describing: MovieDetailFirstSectionCell.self)

    let firstSectionView = MovieDetailFirstSectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(firstSectionView)
        layoutUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movieDetail: MovieDetailDTO, image: UIImage) {
        firstSectionView.configure(with: movieDetail, image: image)
    }

    private func layoutUI() {
        firstSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
