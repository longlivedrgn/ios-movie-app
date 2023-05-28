//
//  MovieGenreViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class MovieGenreViewController: UIViewController {

    private enum Section {
        case main
    }

    private lazy var genreCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.register(GenreListCell.self, forCellWithReuseIdentifier: GenreListCell.identifier)

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
        datasource = UICollectionViewDiffableDataSource(collectionView: genreCollectionView) { collectionView, indexPath, movie in
            print("힝....ㅜㅜ")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreListCell.identifier, for: indexPath) as? GenreListCell else { return UICollectionViewCell() }
            cell.configure(with: movie)
            // movie로 컨피큐어하기~
            return cell
        }
    }
    // layoutEnvironment 다시 공부해보기!
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
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
        print(movies)
        snapShot.appendItems(movies)
    }

}
