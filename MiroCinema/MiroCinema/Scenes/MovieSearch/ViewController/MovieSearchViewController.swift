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
    private let movieSearchModel = MovieSearchModel()

    private let loadingIndicatorView = UIActivityIndicatorView()
    private lazy var searchCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.backgroundColor = .black
        collectionview.delegate = self
        collectionview.register(cell: MovieListViewCell.self)

        return collectionview
    }()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>

    private var datasource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchBar()
        configureCollectionViewDataSource()
        configureNotificationCenter()
        configureBackButton()
        applySnapShot()
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

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(
            collectionView: searchCollectionView
        ) { collectionView, indexPath, movie in
            let cell = collectionView.dequeue(cell: MovieListViewCell.self, for: indexPath)
            cell.configure(with: movie)
            return cell
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
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

    private func applySnapShot() {
        var snapShot = SnapShot()
        let movies = movieSearchModel.movies

        snapShot.appendSections([.main])
        snapShot.appendItems(movies)

        datasource?.apply(snapShot)
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFetchSearchData), name: NSNotification.Name.searchModelDidFetchData, object: nil)
    }

    @objc private func didFetchSearchData(_ notification: Notification) {
        applySnapShot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideIndicatorView()
        }
    }

    private func showIndicatorview() {
        loadingIndicatorView.frame = view.frame
        loadingIndicatorView.backgroundColor = .black
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
    }

    private func hideIndicatorView() {
        loadingIndicatorView.removeFromSuperview()
    }

}

extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchCollectionView.deselectItem(at: indexPath, animated: true)
        guard let movie = datasource?.itemIdentifier(for: indexPath) else { return }

        let movieDetailViewController = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else { return }
        let endPoint = MovieSearchAPIEndPoint(input: text)
        movieSearchModel.movies.removeAll()
        movieSearchModel.searchEndPoint = endPoint
        searchBar.endEditing(true)
        showIndicatorview()
    }

}
