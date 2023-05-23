//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    static let movieDetailSectionHeaderKind = "movieDetailSectionHeaderKind"

    private let movieDetailFirstSectionView = MovieDetailFirstSectionView()

    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createlayout())
        collectionview.register(
            MovieDetailCreditCell.self,
            forCellWithReuseIdentifier: MovieDetailCreditCell.identifier
        )
        collectionview.register(
            MovieDetailFirstSectionCell.self,
            forCellWithReuseIdentifier: MovieDetailFirstSectionCell.identifier
        )
        collectionview.register(
            MovieDetailHeaderView.self,
            forSupplementaryViewOfKind: MovieDetailViewController.movieDetailSectionHeaderKind,
            withReuseIdentifier: MovieDetailHeaderView.identifier
        )
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.contentInsetAdjustmentBehavior = .never

        return collectionview
    }()
    //    var movie: Movie?
    private let networkAPIManager: NetworkAPIManager
    private var credits = ["11","12","13","14","15","16","17","18","19","20"]

    init(movie: Movie, networkAPIManager: NetworkAPIManager) {
        //        self.movie = movie
        self.networkAPIManager = networkAPIManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
    }

    private func setupUI() {
        view.addSubview(movieDetailCollectionView)
        let navigationAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .white
        navigationAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }


    private func layoutUI() {
        movieDetailCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createlayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(600)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.5)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.35),
                    heightDimension: .fractionalHeight(0.2)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: MovieDetailViewController.movieDetailSectionHeaderKind,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [header]

                return section
            default:
                print("설마 여기 타냐?")
                return NSCollectionLayoutSection(
                    group: NSCollectionLayoutGroup(
                        layoutSize: .init(widthDimension: .fractionalHeight(1),
                                          heightDimension: .fractionalHeight(0.5))
                    )
                )
            }
        }
        return layout
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return credits.count
        } else {
            return Int()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let firstSectionCell = movieDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: MovieDetailFirstSectionCell.identifier,
            for: indexPath) as? MovieDetailFirstSectionCell
        else { return UICollectionViewCell() }

        guard let creditCell = movieDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: MovieDetailCreditCell.identifier,
            for: indexPath) as? MovieDetailCreditCell
        else { return UICollectionViewCell() }

        if indexPath.section == 0 {
            return firstSectionCell
        } else if indexPath.section == 1 {
            return creditCell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case MovieDetailViewController.movieDetailSectionHeaderKind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.identifier, for: indexPath)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
