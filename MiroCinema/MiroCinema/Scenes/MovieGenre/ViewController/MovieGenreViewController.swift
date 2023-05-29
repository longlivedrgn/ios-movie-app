//
//  MovieGenreViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class MovieGenreViewController: UIViewController {

    static let movieGenreSectionHeaderKind = "movieGenreSectionHeaderKind"

    private enum Section {
        case main
    }

    private lazy var genreCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.register(GenreListCell.self, forCellWithReuseIdentifier: GenreListCell.identifier)
        collectionview.register(
            MovieGenreHeaderView.self,
            forSupplementaryViewOfKind: MovieGenreViewController.movieGenreSectionHeaderKind,
            withReuseIdentifier: MovieGenreHeaderView.identifier
        )
        return collectionview
    }()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>

    private var datasource: DataSource?
    private let movieGenreController: MovieGenreController

    init(genre: MovieGenre) {
        self.movieGenreController = MovieGenreController(movies: genre.movies?.movies)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCollectionViewDataSource()
        configureNotificationCenter()
        applySnapShot()
    }

    private func configureCollectionView() {
        view.addSubview(genreCollectionView)
        genreCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(
            collectionView: genreCollectionView
        ) { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreListCell.identifier,
                for: indexPath
            ) as? GenreListCell else { return UICollectionViewCell() }
            cell.configure(with: movie)
            // movie로 컨피큐어하기~
            return cell
        }

        datasource?.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieGenreHeaderView.identifier,
                for: indexPath
            ) as? MovieGenreHeaderView else { return UICollectionReusableView() }

            return supplementaryView
        }
    }
    // layoutEnvironment 다시 공부해보기!
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(50)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: MovieGenreViewController.movieGenreSectionHeaderKind,
                alignment: .top
            )
//            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
//                elementKind: UICollectionView.sectionBackgroundDecorationElementKind)
//            sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
            section.boundarySupplementaryItems = [sectionHeader]
//            section.decorationItems = [sectionBackgroundDecoration]


            return section
        }

        return layout
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchData(_:)),
            name: NSNotification.Name("MovieGenreControllerDidFetchData"),
            object: nil
        )
    }

    @objc private func didFetchData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.applySnapShot()
        }
    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])

        let movies = movieGenreController.movies
        snapShot.appendItems(movies)

        datasource?.apply(snapShot)
    }

}
