//
//  MovieStarredViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/27.
//

import UIKit

class MovieStarredViewController: UIViewController {

    private enum Section {
        case main
    }

    private let movieStarredModel = MovieStarredModel()

    static private let movieStarredSupplementaryKind = "movieStarredSupplementaryKind"

    private lazy var starredCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.backgroundColor = .black
        collectionview.register(cell: MovieListViewCell.self)
        collectionview.register(
            supplementaryView: DeleteSupplementaryView.self,
            kind: MovieStarredViewController.movieStarredSupplementaryKind
        )

        return collectionview
    }()

    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(
            title: "영화 선택",
            style: .done,
            target: self,
            action: #selector(deleteButtonTapped)
        )

        return buttonItem
    }()

    private var isDeleteButtonTapped: Bool = false

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>
    private var datasource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBar()
        applySnapShot()
    }

    private func configureCollectionView() {
        view.addSubview(starredCollectionView)
        starredCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureCollectionViewDataSource()
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

            let badgeAnchor = NSCollectionLayoutAnchor(
                edges: [.top, .trailing],
                fractionalOffset: CGPoint(x: 0.25, y: -0.6)
            )

            let badgeSize = NSCollectionLayoutSize(
                widthDimension: .absolute(30),
                heightDimension: .absolute(30)
            )

            let badge = NSCollectionLayoutSupplementaryItem(
                layoutSize: badgeSize,
                elementKind: MovieStarredViewController.movieStarredSupplementaryKind,
                containerAnchor: badgeAnchor
            )

            let movieItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )

            let movieItem = NSCollectionLayoutItem(layoutSize: movieItemSize, supplementaryItems: [badge])

            movieItem.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: 7,
                bottom: 5,
                trailing: 7
            )

            let movieGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3.6)
            )

            let movieGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: movieGroupSize,
                subitems: [movieItem]
            )

            let movieSection = NSCollectionLayoutSection(group: movieGroup)

            return movieSection
        }

        return layout
    }

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(
            collectionView: starredCollectionView
        ) { collectionView, indexPath, movie in
            let cell = collectionView.dequeue(cell: MovieListViewCell.self, for: indexPath)
            cell.configure(with: movie)
            return cell
        }

        datasource?.supplementaryViewProvider = {
            [weak self] (collectionView, kind, indexPath) in

            let supplementaryView = collectionView.dequeue(
                supplementaryView: DeleteSupplementaryView.self,
                for: indexPath,
                kind: MovieStarredViewController.movieStarredSupplementaryKind
            )

            guard let movie = self?.datasource?.itemIdentifier(for: indexPath) else { return UICollectionViewCell()}
            supplementaryView.movie = movie
            supplementaryView.delegate = self
            supplementaryView.isHidden = true

            return supplementaryView
        }
    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([Section.main])

        let movies = movieStarredModel.movies
        snapShot.appendItems(movies, toSection: .main)

        datasource?.apply(snapShot)
    }

    private func configureNavigationBar() {
        navigationItem.title = "내가 찜한 영화들"
        configureNavigationButton()
    }

    private func configureNavigationButton() {
        navigationItem.rightBarButtonItem = deleteBarButtonItem
    }

    @objc private func deleteButtonTapped() {
        isDeleteButtonTapped.toggle()

        switch isDeleteButtonTapped {
        case true:
            deleteBarButtonItem.title = "삭제 완료"
        case false:
            deleteBarButtonItem.title = "영화 선택"
        }
        setMovieCell(isDeleteButtonTapped: isDeleteButtonTapped)
    }

    private func setMovieCell(isDeleteButtonTapped: Bool) {
        let indexPaths = starredCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            setBadgeView(in: indexPath, isTapped: isDeleteButtonTapped)
            setCellAnimation(in: indexPath, isTapped: isDeleteButtonTapped)
        }
    }

    private func setBadgeView(in indexPath: IndexPath, isTapped: Bool) {
        guard let badgeView = starredCollectionView.supplementaryView(
            forElementKind: MovieStarredViewController.movieStarredSupplementaryKind,
            at: indexPath
        ) as? DeleteSupplementaryView else { return }

        badgeView.isHidden = !isTapped
    }

    private func setCellAnimation(in indexPath: IndexPath, isTapped: Bool) {
        let cell = starredCollectionView.cellForItem(at: indexPath)
        if isTapped {
            cell?.layer.add(CAKeyframeAnimation.wobble, forKey: "wobble")
        } else {
            cell?.layer.removeAllAnimations()
        }
    }

}

extension MovieStarredViewController: DeleteSupplementaryViewDelegate {

    func deleteSupplementaryView(_ deleteSupplementaryView: DeleteSupplementaryView, didButtonTapped sender: UIButton) {
        guard let deletedMovie = deleteSupplementaryView.movie else { return }
        guard let deleteMovieIndex = movieStarredModel.movies.firstIndex(of: deletedMovie) else { return }

        movieStarredModel.movies.remove(at: deleteMovieIndex)
        PersistenceManager.shared.delete(movie: deletedMovie)
        applySnapShot()
    }

}


