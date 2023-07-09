//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit
import CoreData

final class MovieDetailViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case detail = 0
        case credit = 1
    }

    static private let movieDetailSectionHeaderKind = "movieDetailSectionHeaderKind"

    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createlayout())
        collectionview.backgroundColor = .black
        collectionview.register(cell: MovieDetailCreditCell.self)
        collectionview.register(cell: MovieDetailFirstSectionCell.self)
        collectionview.register(
            supplementaryView: MovieDetailHeaderView.self,
            kind: MovieDetailViewController.movieDetailSectionHeaderKind
        )

        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.contentInsetAdjustmentBehavior = .never

        return collectionview
    }()

    private lazy var starButton: StarButton = {
        let button = StarButton()
        button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)

        return button
    }()

    private let movieDetailModel: MovieDetailModel

    init(movie: Movie) {
        self.movieDetailModel = MovieDetailModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureNotificationCenter()
        configureNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .black
        navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }

    private func configureNavigationBar() {
        configureRightBarButtonItem()
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }

    private func configureRightBarButtonItem() {
        let starButtonIconItem = UIBarButtonItem(customView: starButton)
        configureStarButtonColor(movieDetailModel.movie)
        navigationItem.rightBarButtonItem = starButtonIconItem
    }

    private func configureStarButtonColor(_ movie: Movie) {
        guard PersistenceManager.shared.isInPersistentContainer(movie: movie) else { return }
        starButton.changeStarredState()
    }

    @objc func starButtonTapped() {
        if starButton.isStarred {
            PersistenceManager.shared.delete(movie: movieDetailModel.movie)
        } else {
            PersistenceManager.shared.star(movie: movieDetailModel.movie)
        }
        starButton.changeStarredState()
    }

    private func configureViews() {
        view.addSubview(movieDetailCollectionView)
        movieDetailCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchMovieDetailData(_:)),
            name: NSNotification.Name.detailModelDidFetchDetailData,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchMovieCreditsData(_:)),
            name: NSNotification.Name.detailModelDidFetchCreditData,
            object: nil
        )
    }

    @objc private func didFetchMovieDetailData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.movieDetailCollectionView.reloadSections([Section.detail.rawValue])
        }
    }

    @objc private func didFetchMovieCreditsData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.movieDetailCollectionView.reloadSections([Section.credit.rawValue])
        }
    }

    private func createlayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            let sectionType = Section.allCases[sectionIndex]
            switch sectionType {
            case .detail:
                return self?.createDetailLayout()
            case .credit:
                return self?.createCreditLayout()
            }
        }
        return layout
    }

    private func createDetailLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(600)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(600)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    private func createCreditLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.45)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalHeight(0.2)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: MovieDetailViewController.movieDetailSectionHeaderKind,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        section.interGroupSpacing = 15
        section.boundarySupplementaryItems = [header]

        return section
    }

}

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let sectionType = Section.allCases[section]

        switch sectionType {
        case .detail:
            return 1
        case .credit:
            return movieDetailModel.movieCredits.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let firstSectionCell = movieDetailCollectionView.dequeue(
            cell: MovieDetailFirstSectionCell.self,
            for: indexPath
        )
        firstSectionCell.firstSectionView.delegate = self

        let creditCell = movieDetailCollectionView.dequeue(
            cell: MovieDetailCreditCell.self,
            for: indexPath
        )
        let sectionType = Section.allCases[indexPath.section]

        switch sectionType {
        case .detail:
            guard let movieDetail = movieDetailModel.movieDetail else { return firstSectionCell }
            firstSectionCell.configure(with: movieDetail)
            return firstSectionCell
        case .credit:
            creditCell.configure(with: movieDetailModel.movieCredits[indexPath.row])
            return creditCell
        }
    }

}

extension MovieDetailViewController: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeue(
            supplementaryView: MovieDetailHeaderView.self,
            for: indexPath,
            kind: kind
        )

        return header
    }

}

extension MovieDetailViewController: MovieDetailFirstSectionViewDelegate {

    func movieDetailFirstSectionView(
        _ movieDetailFirstSectionView: MovieDetailFirstSectionView,
        didButtonTapped sender: UIButton
    ) {
        guard let button = sender as? ViewMoreButton else { return }

        switch button.isTapped {
        case true:
            movieDetailFirstSectionView.overViewLabel.numberOfLines = 2
        case false:
            movieDetailFirstSectionView.overViewLabel.numberOfLines = 0
        }
        button.isTapped.toggle()
        button.setButtonTitle()
        self.movieDetailCollectionView.reloadData()
    }

}


