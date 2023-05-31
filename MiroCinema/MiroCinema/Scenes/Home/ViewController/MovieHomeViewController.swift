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

    private struct ItemType: Hashable {

        var item: any ItemIdenfiable

        static func == (lhs: MovieHomeViewController.ItemType, rhs: MovieHomeViewController.ItemType) -> Bool {
            return lhs.item.identity == rhs.item.identity
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(item)
        }

    }

    private enum Section: CaseIterable {
        case rank
        case genre
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemType>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, ItemType>

    private var datasource: DataSource?
    private let movieHomeController = MovieHomeController()

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
        collectionView.register(
            MovieRankCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieRankCollectionViewCell.identifier
        )
        collectionView.register(
            MovieRankHeaderView.self,
            forSupplementaryViewOfKind: MovieHomeViewController.movieRankSectionHeaderKind,
            withReuseIdentifier: MovieRankHeaderView.identifier
        )
        collectionView.register(
            MovieGenresCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieGenresCollectionViewCell.identifier
        )
        collectionView.register(
            MovieHomeGenresHeaderView.self,
            forSupplementaryViewOfKind: MovieHomeViewController.movieGenresSectionHeaderKind,
            withReuseIdentifier: MovieHomeGenresHeaderView.identifier
        )

        collectionView.register(
            MovieGenresFooterView.self,
            forSupplementaryViewOfKind: MovieHomeViewController.movieGenresSectionFooterKind,
            withReuseIdentifier: MovieGenresFooterView.identifer
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]

            switch section {
            case .rank:
                return self.createRankLayout()
            case .genre:
                return self.createGenresLayout()
            }
        }
        return layout
    }

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView)
        { collectionView, indexPath, item in
            switch item.item {
            case is Movie:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieRankCollectionViewCell.identifier,
                    for: indexPath) as? MovieRankCollectionViewCell else { return UICollectionViewCell() }
                guard let items = item.item as? Movie else { return UICollectionViewCell() }
                cell.configure(with: items)
                return cell
            case is MovieGenre:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieGenresCollectionViewCell.identifier,
                    for: indexPath) as? MovieGenresCollectionViewCell else { return UICollectionViewCell()}
                guard let items = item.item as? MovieGenre else { return UICollectionViewCell() }
                cell.configure(with: items)
                return cell
            default:
                return UICollectionViewCell()
            }
        }

        datasource?.supplementaryViewProvider = {
            (collectionView, kind, indexPath) in

            let sectionType = Section.allCases[indexPath.section]

            switch sectionType {
            case .rank:
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MovieRankHeaderView.identifier,
                    for: indexPath) as? MovieRankHeaderView
                else { return UICollectionReusableView() }
                supplementaryView.delegate = self
                return supplementaryView
            case .genre:
                switch kind {
                case MovieHomeViewController.movieGenresSectionHeaderKind:
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MovieHomeGenresHeaderView.identifier,
                        for: indexPath) as? MovieHomeGenresHeaderView
                    else { return UICollectionReusableView() }
                    return supplementaryView
                case MovieHomeViewController.movieGenresSectionFooterKind:
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MovieGenresFooterView.identifer,
                        for: indexPath) as? MovieGenresFooterView
                    else { return UICollectionReusableView() }
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

        var rankMovies = movieHomeController.movies
        let movieItems = rankMovies.map { ItemType(item:$0) }
        snapShot.appendItems(movieItems, toSection: .rank)

        var allGenres = movieHomeController.genres
        let genreItems = allGenres.map { ItemType(item: $0) }
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
            name: NSNotification.Name("MovieHomeControllerDidFetchData"),
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
        let ticketButtonIcon = UIImage(named: "ticketButtonIcon")
        let ticketButtonIconItem = UIBarButtonItem(customView: UIImageView(image: ticketButtonIcon))

        let mapButtonColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        let mapButtonIcon = UIImage(systemName: "map")?.withTintColor(
            mapButtonColor,
            renderingMode: .alwaysOriginal
        )
        let mapButtonIconItem = UIBarButtonItem(customView: UIImageView(image: mapButtonIcon))

        let hamburgerButtonIcon = UIImage(named: "hamburgerButtonIcon")
        let hamburgerButtonIconItem = UIBarButtonItem(
            customView: UIImageView(image: hamburgerButtonIcon)
        )

        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16

        self.navigationItem.rightBarButtonItems = [
            hamburgerButtonIconItem,
            spacer,
            mapButtonIconItem,
            spacer,
            ticketButtonIconItem,
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

}

extension MovieHomeViewController: UICollectionViewDelegate {

//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            collectionView.deselectItem(at: indexPath, animated: true)
//            guard let movie = datasource?.itemIdentifier(for: indexPath) else { return }
//
//            switch movie {
//            case .rank(let movie):
//                let movieDetailViewController = MovieDetailViewController(movie: movie)
//                navigationController?.pushViewController(movieDetailViewController, animated: true)
//            case .gerne(let genre):
//                let movieGenreViewController = MovieGenreViewController(genre: genre)
//                movieGenreViewController.title = genre.genreTitle
//                navigationController?.pushViewController(movieGenreViewController, animated: true)
//            }
//        }

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
