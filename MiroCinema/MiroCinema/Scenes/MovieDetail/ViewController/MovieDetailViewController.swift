//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    private let movieDetailFirstSectionView = MovieDetailFirstSectionView()

    private let detailCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createlayout())
        

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
        view.addSubview(movieDetailFirstSectionView)
        configureLayout()

    }

    private func configureLayout() {
        movieDetailFirstSectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(700)
        }

//    }
//
    private func createlayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let creditItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)
            )
            let creditItem = NSCollectionLayoutItem(layoutSize: creditItemSize)

            //            creditItem.contentInsets = NSDirectionalEdgeInsets(
            //                top: 10,
            //                leading: 10,
            //                bottom: 10,
            //                trailing: 10
            //            )

            let creditGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalHeight(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let creditGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: creditGroupSize,
                subitems: [creditItem, creditItem]
            )

            //            let movieRankHeaderSize = NSCollectionLayoutSize(
            //                widthDimension: .fractionalWidth(1.0),
            //                heightDimension: .absolute(44)
            //            )
            //
            //            let movieRankHeader = NSCollectionLayoutBoundarySupplementaryItem(
            //                layoutSize: movieRankHeaderSize,
            //                elementKind: MiroCinemaViewController.movieRankSectionHeaderKind,
            //                alignment: .top
            //            )

            let creditSection = NSCollectionLayoutSection(group: creditGroup)
            //            movieRankSection.boundarySupplementaryItems = [movieRankHeader]

            creditSection.orthogonalScrollingBehavior = .continuous

            return creditSection
        }

        return layout
    }


}

//extension MovieDetailViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("뭔데")
//        return credits.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("여기타냐?")
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCreditCollectionViewCell.identifier, for: indexPath) as? MovieDetailCreditCollectionViewCell else { return UICollectionViewCell() }
//        return cell
//    }

}
