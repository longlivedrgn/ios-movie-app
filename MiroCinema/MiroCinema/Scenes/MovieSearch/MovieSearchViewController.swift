//
//  MovieSearchViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

class MovieSearchViewController: UIViewController {

    private enum Section {
        case main
    }

    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    private lazy var searchCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.backgroundColor = .black
        collectionview.delegate = self
        collectionview.register(cell: MovieGenreListCell.self)

        return collectionview
    }()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>

    private var datasource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureSearchBar()
    }

    private func configureViews() {
        view.backgroundColor = .green
        configureCollectionView()
    }

    private func configureCollectionView() {
        view.addSubview(searchCollectionView)
        searchCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "작품의 제목을 검색해보세요"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

            let movieItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(0.35)
            )

            let movieItem = NSCollectionLayoutItem(layoutSize: movieItemSize)

            movieItem.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 10,
                bottom: 10,
                trailing: 10
            )

            let movieGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/3)
            )

            let movieGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: movieGroupSize,
                subitems: [movieItem, movieItem, movieItem]
            )

            movieGroup.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 20
            )

            let movieSection = NSCollectionLayoutSection(group: movieGroup)

            return movieSection
        }

        return layout
    }

}

extension MovieSearchViewController: UICollectionViewDelegate {

}

extension MovieSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else { return }
        let endPoint = MovieSearchAPIEndPoint(input: text)

        Task {
            do {
                let decodedData = try await movieNetworkAPIManager.fetchData(to: MoviesDTO.self, endPoint: endPoint)
                guard let movie = decodedData as? MoviesDTO else { return }
                print(movie.movies.first ?? 0)
            }
        }
    }

}
