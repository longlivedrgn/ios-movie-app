//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    private lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = movie?.posterImage

        return imageView
    }()

    private let movieDetailCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()

    var movie: Movie?
    private let networkAPIManager: NetworkAPIManager

    init(movie: Movie, networkAPIManager: NetworkAPIManager) {
        self.movie = movie
        self.networkAPIManager = networkAPIManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(moviePosterImageView)
        configureLayout()
        configureMoviePosterImageView()
    }

    private func configureLayout() {
        moviePosterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
    }

    private func configureMoviePosterImageView() {
        view.layoutIfNeeded()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = moviePosterImageView.bounds
        let colors: [CGColor] = [.init(gray: 0.0, alpha: 0.5), .init(gray: 0.0, alpha: 1)]
        gradientLayer.locations = [0.25, 0.7]
        gradientLayer.colors = colors

        moviePosterImageView.layer.addSublayer(gradientLayer)
    }

}
