//
//  MiroCinemaViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/17.
//

import UIKit
import SnapKit

final class MiroCinemaViewController: UIViewController {

    static let movieRankSectionHeaderKind = "movieRankSectionHeaderKind"
    static let movieGenresSectionHeaderKind = "movieGenresSectionHeaderKind"
    static let movieGenresSectionFooterKind = "movieGenresSectionFooterKind"

    private enum Section: CaseIterable {
        case rank
        case genre
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Movie>

    private var datasource: DataSource?
    // 💥 Mock으로 빼두기~
    private var movies = [
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage")),
        Movie(title: "-", posterImage: UIImage(named: "grayImage"))
    ] {
        didSet {
            applySnapShot()
        }
    }

    private var genres = [
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
        Movie(backDropImage: UIImage(named: "grayImage"), genreTitle: "-"),
    ] {
        didSet {
            applySnapShot()
        }
    }
    private var allGenres = [Movie]()
    private let movieNetworkManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    private let navigationTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "미로 시네마"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .systemBackground

        return titleLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(
            MovieRankCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieRankCollectionViewCell.identifier
        )
        collectionView.register(
            MovieRankHeaderView.self,
            forSupplementaryViewOfKind: MiroCinemaViewController.movieRankSectionHeaderKind,
            withReuseIdentifier: MovieRankHeaderView.identifier
        )
        collectionView.register(
            MovieGenresCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieGenresCollectionViewCell.identifier
        )
        collectionView.register(
            MovieGenresHeaderView.self,
            forSupplementaryViewOfKind: MiroCinemaViewController.movieGenresSectionHeaderKind,
            withReuseIdentifier: MovieGenresHeaderView.identifier
        )

        collectionView.register(
            MovieGenresFooterView.self,
            forSupplementaryViewOfKind: MiroCinemaViewController.movieGenresSectionFooterKind,
            withReuseIdentifier: MovieGenresFooterView.identifer
        )

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        fetchData()
        configureNavigationBar()
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        applySnapShot()
    }

    private func fetchData() {
        let movieRankEndPoint = MovieRankAPIEndPoint()
        Task {
            do {
                let decodedData = try await movieNetworkManager.fetchData(
                    to: MoviesDTO.self,
                    endPoint: movieRankEndPoint
                )
                guard let movieRank = decodedData as? MoviesDTO else { return }
                // 영화 개봉순으로 정렬하기 알고리즘 추가하기
                let movieList = movieRank.movies.prefix(10)

                for (index, movieDTO) in movieList.enumerated() {
                    let title = movieDTO.koreanTitle
                    let id = movieDTO.ID
                    let releaseDate = movieDTO.releaseDate.convertToDate()
                    // 옵셔널 에러 처리해야될듯 -> 만약 posterPath가 없다면??
                    guard let posterPath = movieDTO.posterPath else { return }
                    let imageEndPoint = MovieImageAPIEndPoint(imageURL: posterPath)
                    let imageResult = try await movieNetworkDispatcher.performRequest(imageEndPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        let movie = Movie(id: id, title: title, releaseDate: releaseDate, posterImage: posterImage)
                        movies[index] = movie
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }

        let genreEndPoint = MovieGenreAPIEndPoint(genre: .action)
        let genreEndPoint2 = MovieGenreAPIEndPoint(genre: .documentary)
        let genreEndPoint3 = MovieGenreAPIEndPoint(genre: .animation)
        let genreEndPoint4 = MovieGenreAPIEndPoint(genre: .comedy)
        let genreEndPoint5 = MovieGenreAPIEndPoint(genre: .history)
        let genreEndPoint6 = MovieGenreAPIEndPoint(genre: .romance)
        let genreEndPoint7 = MovieGenreAPIEndPoint(genre: .fantasy)
        let genreEndPoint8 = MovieGenreAPIEndPoint(genre: .drama)
        let genreEndPoint9 = MovieGenreAPIEndPoint(genre: .scienceFiction)
        let genreEndPoint10 = MovieGenreAPIEndPoint(genre: .scienceFiction)
        let genreEndPoint11 = MovieGenreAPIEndPoint(genre: .scienceFiction)
        let genreEndPoint12 = MovieGenreAPIEndPoint(genre: .scienceFiction)

        let genreList = [genreEndPoint, genreEndPoint2, genreEndPoint3, genreEndPoint4, genreEndPoint5, genreEndPoint6, genreEndPoint7, genreEndPoint8, genreEndPoint9, genreEndPoint10, genreEndPoint11, genreEndPoint12]

        Task {
            do {
                for (index, genreEndPoint) in genreList.enumerated() {
                    let actionDecodedData = try await movieNetworkManager.fetchData(
                        to: MoviesDTO.self,
                        endPoint: genreEndPoint
                    )
                    guard let action = actionDecodedData as? MoviesDTO else { return }
                    guard let actionMoviesFirst = action.movies.first else { return }
                    guard let backDropImagePath = actionMoviesFirst.backDropImagePath else { return }
                    let actionImageEndPoint = MovieImageAPIEndPoint(imageURL: backDropImagePath)
                    let actionId = actionMoviesFirst.ID
                    let actionTitle = actionMoviesFirst.koreanTitle
                    let actionimageResult = try await movieNetworkDispatcher.performRequest(actionImageEndPoint.urlRequest)

                    switch actionimageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        let movie = Movie(id: actionId, title: actionTitle, backDropImage: posterImage, genreTitle: genreEndPoint.genre.description)
                        if (0...5).contains(index) {
                            genres[index] = movie
                        }
                        allGenres.append(movie)
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
            applySnapShot()
        }

    }

    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.rank])
        snapShot.appendItems(movies)

        snapShot.appendSections([.genre])
        snapShot.appendItems(genres)

        datasource?.apply(snapShot)
    }

    private func applyAllSnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.rank])
        snapShot.appendItems(movies)

        snapShot.appendSections([.genre])
        snapShot.appendItems(allGenres)
        
        datasource?.apply(snapShot)
    }

    private func configureCollectionViewDataSource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView)
        { collectionView, indexPath, movie in

            let sectionType = Section.allCases[indexPath.section]

            switch sectionType {
            case .rank:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieRankCollectionViewCell.identifier,
                    for: indexPath) as? MovieRankCollectionViewCell
                cell?.configure(with: movie)
                return cell
            case .genre:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MovieGenresCollectionViewCell.identifier,
                    for: indexPath) as? MovieGenresCollectionViewCell
                cell?.configure(with: movie)
                return cell
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
                    for: indexPath) as? MovieRankHeaderView else { return UICollectionReusableView() }
                supplementaryView.delegate = self

                return supplementaryView
            case .genre:
                // 💥 코드 로직 수정하기!! switch 문 안에 switch문이라니!!
                switch kind {
                case MiroCinemaViewController.movieGenresSectionHeaderKind:
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MovieGenresHeaderView.identifier,
                        for: indexPath) as? MovieGenresHeaderView else { return UICollectionReusableView() }
                    return supplementaryView
                case MiroCinemaViewController.movieGenresSectionFooterKind:
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MovieGenresFooterView.identifer,
                        for: indexPath) as? MovieGenresFooterView  else { return UICollectionReusableView() }
                    supplementaryView.delegate = self
                    return supplementaryView
                default:
                    return UICollectionReusableView()
                }
            }
        }

        applySnapShot()
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
                return self.generateMovieRankLayout()
            case .genre:
                return self.generateMovieGenresLayout()
            }
        }
        return layout
    }

    private func generateMovieRankLayout() -> NSCollectionLayoutSection {

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
            elementKind: MiroCinemaViewController.movieRankSectionHeaderKind,
            alignment: .top
        )

        let movieRankSection = NSCollectionLayoutSection(group: movieGroup)
        movieRankSection.boundarySupplementaryItems = [movieRankHeader]

        movieRankSection.orthogonalScrollingBehavior = .groupPaging

        return movieRankSection
    }

    private func generateMovieGenresLayout() -> NSCollectionLayoutSection {

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
            elementKind: MiroCinemaViewController.movieGenresSectionHeaderKind,
            alignment: .top
        )

        let movieGenresFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(55)
        )

        let movieGenresFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: movieGenresFooterSize,
            elementKind: MiroCinemaViewController.movieGenresSectionFooterKind,
            alignment: .bottom
        )

        let movieGenresSection = NSCollectionLayoutSection(group: movieGenresGroup)
        movieGenresSection.boundarySupplementaryItems = [movieGenresHeader, movieGenresFooter]

        return movieGenresSection
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        configureNavigationTitle()
        configureNavigationButton()
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

}

extension MiroCinemaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = datasource?.itemIdentifier(for: indexPath) else { return }
        let movieDetailViewController = MovieDetailViewController(
            movie: movie,
            networkAPIManager: movieNetworkManager
        )
        collectionView.deselectItem(at: indexPath, animated: true)
        // MARK: 💥 back button 수정하는 로직 수정하기!
        let backButtonBackgroundImage = UIImage(systemName: "list.bullet")
        let barAppearance =
            UINavigationBar.appearance(whenContainedInInstancesOf: [MovieDetailViewController.self])
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension MiroCinemaViewController: MovieGenresFooterViewDelegate {

    func movieGenresFooterView(_ movieGenresFooterView: MovieGenresFooterView, didButtonTapped sender: UIButton) {
        guard let button = sender as? ViewMoreButton else { return }

        switch button.isTapped {
        case true:
            applySnapShot()
        case false:
            applyAllSnapShot()
        }
        button.isTapped.toggle()
        button.setButtonTitle()
    }

    private func applySnapShot2() {
        var snapShot = SnapShot()
        snapShot.appendSections([.rank])
        let sortedMovies = movies.sorted {
            $0.releaseDate ?? Date() > $1.releaseDate ?? Date()
        }
        snapShot.appendItems(sortedMovies)

        snapShot.appendSections([.genre])
        snapShot.appendItems(genres)

        datasource?.apply(snapShot)
    }

}

extension MiroCinemaViewController: MovieRankHeaderViewDelegate {

    func movieRankHeaderView(
        _ movieRankHeaderView: MovieRankHeaderView,
        didButtonTapped sender: RankSortButton
    ) {
        guard let sort = sender.sort else { return }
        switch sort {
        case .reservationRate:
            movieRankHeaderView.changeButtonColor(clickedButton: sender)
            applySnapShot()
        case .openDate:
            movieRankHeaderView.changeButtonColor(clickedButton: sender)
            applySnapShot2()
        }
    }

}
