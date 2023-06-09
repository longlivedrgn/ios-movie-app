//
//  MovieGenreViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class MovieGenreViewController: UIViewController {

    static let movieGenreSectionHeaderKind = "movieGenreSectionHeaderKind"
    static let movieGenreSectionBackgroundKind = "movieGenreSectionBackgroundKind"

    private enum Section {
        case main
    }

    private lazy var genreCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.backgroundColor = .black
        collectionview.delegate = self
        collectionview.register(cell: MovieGenreListCell.self)
        collectionview.register(
            supplementaryView: MovieGenreHeaderView.self,
            kind: MovieGenreViewController.movieGenreSectionHeaderKind
        )

        return collectionview
    }()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>

    private var datasource: DataSource?
    private let movieGenreModel: MovieGenreModel

    init(genre: MovieGenre) {
        self.movieGenreModel = MovieGenreModel(movies: genre.movies?.movies)
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
        configureBackButton()
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
            let cell = collectionView.dequeue(cell: MovieGenreListCell.self, for: indexPath)
            cell.configure(with: movie)
            return cell
        }

        datasource?.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in
            let supplementaryView = collectionView.dequeue(
                supplementaryView: MovieGenreHeaderView.self,
                for: indexPath,
                kind: kind
            )

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
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: MovieGenreViewController.movieGenreSectionBackgroundKind
            )
            section.interGroupSpacing = 7
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
            section.boundarySupplementaryItems = [sectionHeader]
            section.decorationItems = [sectionBackgroundDecoration]

            return section
        }

        layout.register(
            MovieGenreSectionBackgroundDecorationView.self,
            forDecorationViewOfKind: MovieGenreViewController.movieGenreSectionBackgroundKind
        )

        return layout
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchData(_:)),
            name: NSNotification.Name.genreModelDidFetchData,
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

        let movies = movieGenreModel.movies
        snapShot.appendItems(movies)

        datasource?.apply(snapShot)
    }

}

extension MovieGenreViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let movie = datasource?.itemIdentifier(for: indexPath) else { return }

        let movieDetailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

}
