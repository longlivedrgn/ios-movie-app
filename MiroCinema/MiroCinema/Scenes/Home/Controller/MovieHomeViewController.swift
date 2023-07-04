//
//  MovieHomeViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/17.
//

import UIKit
import SnapKit

final class MovieHomeViewController: UIViewController {

    static let movieRankSectionHeaderKind = "movieRankSectionHeaderKind"
    static let movieGenresSectionHeaderKind = "movieGenresSectionHeaderKind"
    static let movieGenresSectionFooterKind = "movieGenresSectionFooterKind"

    private enum Item: Hashable {
        case rank(Movie)
        case gerne(MovieGenre)
    }

    private enum Section: CaseIterable {
        case rank
        case genre
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>

    private var datasource: DataSource?
    private let movieHomeModel = MovieHomeModel()

    var isRankSortedByOpenDate = false
    var isMoreButtonTapped = false

    private let navigationTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "미로 시네마🍿"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .white

        return titleLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.register(cell: MovieRankCollectionViewCell.self)
        collectionView.register(cell: MovieGenresCollectionViewCell.self)
        collectionView.register(
            supplementaryView: MovieRankHeaderView.self,
            kind: MovieHomeViewController.movieRankSectionHeaderKind
        )
        collectionView.register(
            supplementaryView: MovieHomeGenresHeaderView.self,
            kind: MovieHomeViewController.movieGenresSectionHeaderKind
        )
        collectionView.register(
            supplementaryView: MovieGenresFooterView.self,
            kind: MovieHomeViewController.movieGenresSectionFooterKind
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        applySnapShot()
        configureNotificationCenter()
        configureNavigationBar()
    }

    private func configureView() {
        view.addSubview(collectionView)
    }

    private func configureCollectionViewLayout() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        collectionView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(safeAreaGuide.snp.top).offset(30)
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]

            switch section {
            case .rank:
                return self?.createRankLayout()
            case .genre:
                return self?.createGenresLayout()
            }
        }
        return layout
    }

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView)
        { collectionView, indexPath, item in

            switch item {
            case .rank(let movie):
                let cell = collectionView.dequeue(cell: MovieRankCollectionViewCell.self, for: indexPath)
                cell.configure(with: movie)
                return cell
            case .gerne(let genre):
                let cell = collectionView.dequeue(cell: MovieGenresCollectionViewCell.self, for: indexPath)
                cell.configure(with: genre)
                return cell
            }
        }

        datasource?.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in

            let sectionType = Section.allCases[indexPath.section]

            switch sectionType {
            case .rank:
                let supplementaryView = collectionView.dequeue(
                    supplementaryView: MovieRankHeaderView.self,
                    for: indexPath,
                    kind: kind
                )
                supplementaryView.delegate = self
                return supplementaryView
            case .genre:
                switch kind {
                case MovieHomeViewController.movieGenresSectionHeaderKind:
                    let supplementaryView = collectionView.dequeue(
                        supplementaryView: MovieHomeGenresHeaderView.self,
                        for: indexPath,
                        kind: kind
                    )
                    return supplementaryView
                case MovieHomeViewController.movieGenresSectionFooterKind:
                    let supplementaryView = collectionView.dequeue(
                        supplementaryView: MovieGenresFooterView.self,
                        for: indexPath,
                        kind: kind
                    )
                    supplementaryView.delegate = self
                    return supplementaryView
                default:
                    return UICollectionReusableView()
                }
            }
        }
    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections(Section.allCases)

        var rankMovies = movieHomeModel.movies
        if isRankSortedByOpenDate {
            rankMovies = rankMovies.sorted { $0.releaseDate ?? Date() > $1.releaseDate ?? Date() }
        }
        let movieItems = rankMovies.map { Item.rank($0) }
        snapShot.appendItems(movieItems, toSection: .rank)

        var allGenres = movieHomeModel.genres
        if !isMoreButtonTapped {
            allGenres = Array(allGenres.prefix(6))
        }
        let genreItems = allGenres.map { Item.gerne($0) }
        snapShot.appendItems(genreItems, toSection: .genre)

        datasource?.apply(snapShot)
    }

    private func createRankLayout() -> NSCollectionLayoutSection {

        let movieItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.7)
        )
        let movieItem = NSCollectionLayoutItem(layoutSize: movieItemSize)

        movieItem.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )

        let movieGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalWidth(0.8)
        )

        let movieGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: movieGroupSize,
            subitems: [movieItem]
        )

        let movieRankHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )

        let movieRankHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: movieRankHeaderSize,
            elementKind: MovieHomeViewController.movieRankSectionHeaderKind,
            alignment: .top
        )

        let movieRankSection = NSCollectionLayoutSection(group: movieGroup)
        movieRankSection.boundarySupplementaryItems = [movieRankHeader]

        movieRankSection.orthogonalScrollingBehavior = .groupPaging

        return movieRankSection
    }

    private func createGenresLayout() -> NSCollectionLayoutSection {

        let movieGenreItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(0.35)
        )

        let movieGenreItem = NSCollectionLayoutItem(layoutSize: movieGenreItemSize)

        movieGenreItem.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )

        let movieGenresGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3)
        )

        let movieGenresGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: movieGenresGroupSize,
            subitems: [movieGenreItem, movieGenreItem, movieGenreItem]
        )

        movieGenresGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 20
        )

        let movieGenresHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let movieGenresHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: movieGenresHeaderSize,
            elementKind: MovieHomeViewController.movieGenresSectionHeaderKind,
            alignment: .top
        )

        let movieGenresFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(55)
        )

        let movieGenresFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: movieGenresFooterSize,
            elementKind: MovieHomeViewController.movieGenresSectionFooterKind,
            alignment: .bottom
        )

        let movieGenresSection = NSCollectionLayoutSection(group: movieGenresGroup)
        movieGenresSection.boundarySupplementaryItems = [movieGenresHeader, movieGenresFooter]

        return movieGenresSection
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFetchData(_:)),
            name: NSNotification.Name.homeModelDidFetchData,
            object: nil
        )
    }

    @objc private func didFetchData(_ notification: Notification) {
        DispatchQueue.main.async {
            self.applySnapShot()
        }
    }

    private func configureNavigationBar() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .black
        navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        configureNavigationTitle()
        configureNavigationButton()
        configureNavigationBackButton()
    }

    private func configureNavigationTitle() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navigationTitle)
    }

    private func configureNavigationButton() {
        // TODO: 요것도 빼자!
        let buttonColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

        let magnifyingglassButtonIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(
            buttonColor,
            renderingMode: .alwaysOriginal
        )
        let magnifyingglassButton = UIButton(type: .custom)
        magnifyingglassButton.setImage(magnifyingglassButtonIcon, for: .normal)
        magnifyingglassButton.addTarget(self, action: #selector(magnifyingglassButtonTapped), for: .touchUpInside)
        let magnifyingglassButtonIconItem = UIBarButtonItem(customView: magnifyingglassButton)

        let mapButtonIcon = UIImage(systemName: "map")?.withTintColor(
            buttonColor,
            renderingMode: .alwaysOriginal
        )
        let mapButtonIconItem = UIBarButtonItem(customView: UIImageView(image: mapButtonIcon))

        let starButtonIcon = UIImage(systemName: "star")?.withTintColor(
            buttonColor,
            renderingMode: .alwaysOriginal
        )
        let starButton = UIButton(type: .custom)
        starButton.setImage(starButtonIcon, for: .normal)
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        let starButtonIconItem = UIBarButtonItem(customView: starButton)

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16

        self.navigationItem.rightBarButtonItems = [
            mapButtonIconItem,
            spacer,
            starButtonIconItem,
            spacer,
            magnifyingglassButtonIconItem,
        ]
    }

    private func configureNavigationBackButton() {
        let backButtonBackgroundImage = UIImage(systemName: "list.bullet")
        let barAppearance = UINavigationBar.appearance(
            whenContainedInInstancesOf: [MovieDetailViewController.self]
        )
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        backBarButton.tintColor = .white
        navigationItem.backBarButtonItem = backBarButton
    }

    @objc func magnifyingglassButtonTapped() {
        let movieSearchViewController = MovieSearchViewController()
        navigationController?.pushViewController(movieSearchViewController, animated: true)
    }

    @objc func starButtonTapped() {
        let movieStarredViewController = MovieStarredViewController()
        navigationController?.pushViewController(movieStarredViewController, animated: true)
    }

}

extension MovieHomeViewController: UICollectionViewDelegate {

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            guard let movie = datasource?.itemIdentifier(for: indexPath) else { return }

            switch movie {
            case .rank(let movie):
                let movieDetailViewController = MovieDetailViewController(movie: movie)
                navigationController?.pushViewController(movieDetailViewController, animated: true)
            case .gerne(let genre):
                let movieGenreViewController = MovieGenreViewController(genre: genre)
                movieGenreViewController.title = genre.genreTitle
                navigationController?.pushViewController(movieGenreViewController, animated: true)
            }
        }

}

extension MovieHomeViewController: MovieGenresFooterViewDelegate {

    func movieGenresFooterView(_ movieGenresFooterView: MovieGenresFooterView, didButtonTapped sender: UIButton) {
        guard let button = sender as? ViewMoreButton else { return }
        button.isTapped.toggle()
        isMoreButtonTapped.toggle()
        applySnapShot()
        scrollToBottom()
        button.setButtonTitle()
    }
    // 💥 공부다시해보기..ㅜㅜ
    private func scrollToBottom() {
        let lastSection = collectionView.numberOfSections - 1
        let footerIndexPath = IndexPath(item: 0, section: lastSection)
        guard let footerView = self.collectionView.layoutAttributesForSupplementaryElement(
            ofKind: MovieHomeViewController.movieGenresSectionFooterKind,
            at: footerIndexPath
        ) else { return }

        let footerFrame = footerView.frame
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let visibleContentHeight = self.collectionView.bounds.height - navigationBarHeight
        let contentOffset = footerFrame.origin.y + footerFrame.height - visibleContentHeight

        self.collectionView.setContentOffset(CGPoint(x: 0, y: contentOffset), animated: true)
    }

}

extension MovieHomeViewController: MovieRankHeaderViewDelegate {

    func movieRankHeaderView(
        _ movieRankHeaderView: MovieRankHeaderView,
        didButtonTapped sender: RankSortButton
    ) {
        isRankSortedByOpenDate.toggle()
        movieRankHeaderView.changeButtonColor(clickedButton: sender)
        applySnapShot()
    }

}
