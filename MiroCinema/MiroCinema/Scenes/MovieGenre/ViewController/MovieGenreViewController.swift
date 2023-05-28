//
//  MovieGenreViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

class MovieGenreViewController: UIViewController {

    private lazy var genreCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionview.register(GenreListCell.self, forCellWithReuseIdentifier: GenreListCell.identifier)
        collectionview.dataSource = self

        return collectionview
    }()

    var genreMovies: [MovieDTO]?

    init(genre: MovieGenre) {
        self.genreMovies = genre.movies?.movies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        print(genreMovies?.count)
    }

    private func configureCollectionView() {
        view.addSubview(genreCollectionView)
    }
    // layoutEnvironment 다시 공부해보기!
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)

            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        return layout
    }

}

extension MovieGenreViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreMovies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreListCell.identifier, for: indexPath) as? GenreListCell else { return UICollectionViewCell() }

        return movieCell
    }

}

extension MovieGenreViewController: UICollectionViewDelegate {

}
