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

    private lazy var starredCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createBasicLayout())
        collectionview.backgroundColor = .black
        collectionview.register(cell: MovieListViewCell.self)

        return collectionview
    }()
    private lazy var deleteBarButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "영화 선택", style: .plain, target: self, action: #selector(deleteButtonTapped))

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

    private func createBasicLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

            let movieItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )

            let movieItem = NSCollectionLayoutItem(layoutSize: movieItemSize)

            movieItem.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 5,
                bottom: 5,
                trailing: 5
            )

            let movieGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3.6)
            )

            let movieGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: movieGroupSize,
                subitems: [movieItem, movieItem, movieItem]
            )

            let movieSection = NSCollectionLayoutSection(group: movieGroup)

            return movieSection
        }

        return layout
    }

    private func createDeleteModeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

            let movieItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )

            let movieItem = NSCollectionLayoutItem(layoutSize: movieItemSize)

            movieItem.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 5,
                bottom: 5,
                trailing: 5
            )

            let movieGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3.6)
            )

            let movieGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: movieGroupSize,
                subitems: [movieItem, movieItem, movieItem]
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
            starredCollectionView.setCollectionViewLayout(createDeleteModeLayout(), animated: true)
        case false:
            deleteBarButtonItem.title = "영화 선택"
            starredCollectionView.setCollectionViewLayout(createBasicLayout(), animated: true)
        }
    }

}

