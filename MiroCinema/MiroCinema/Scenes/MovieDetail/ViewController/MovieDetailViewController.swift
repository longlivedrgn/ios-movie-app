//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailViewController: UIViewController {

    private enum Section: CaseIterable {
        case detail
        case credit
    }

    static let movieDetailSectionHeaderKind = "movieDetailSectionHeaderKind"

    private lazy var movieDetailCollectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createlayout())
        collectionview.backgroundColor = .black
        collectionview.register(
            MovieDetailCreditCell.self,
            forCellWithReuseIdentifier: MovieDetailCreditCell.identifier
        )
        collectionview.register(
            MovieDetailFirstSectionCell.self,
            forCellWithReuseIdentifier: MovieDetailFirstSectionCell.identifier
        )
        collectionview.register(
            MovieDetailHeaderView.self,
            forSupplementaryViewOfKind: MovieDetailViewController.movieDetailSectionHeaderKind,
            withReuseIdentifier: MovieDetailHeaderView.identifier
        )
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.contentInsetAdjustmentBehavior = .never

        return collectionview
    }()

    private let movie: Movie
    // 💥 요것도 Model로 만들어서 넣어주면 좋을듯!
    private var movieDetail: MovieDetailsDTO?
    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()
    private var movieCredits = [MovieCredit](
        repeating: MovieCredit(name: "-", department: "-", profileImage: UIImage(named: "grayImage")),
        count: 16
    )

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetails()
        setupUI()
        layoutUI()
        fetchMovieCredits()
    }

    private func setupUI() {
        view.addSubview(movieDetailCollectionView)
        let navigationAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .white
        navigationAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }

    private func layoutUI() {
        movieDetailCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func createlayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let sectionType = Section.allCases[sectionIndex]
            switch sectionType {
            case .detail:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(600)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                return section
            case .credit:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .fractionalWidth(0.45)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .fractionalHeight(0.225)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item, item]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
                section.interGroupSpacing = 15
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: MovieDetailViewController.movieDetailSectionHeaderKind,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [header]

                return section
            }
        }
        return layout
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
            return movieCredits.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let firstSectionCell = movieDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: MovieDetailFirstSectionCell.identifier,
            for: indexPath) as? MovieDetailFirstSectionCell
        else { return UICollectionViewCell() }
        firstSectionCell.firstSectionView.delegate = self

        guard let creditCell = movieDetailCollectionView.dequeueReusableCell(
            withReuseIdentifier: MovieDetailCreditCell.identifier,
            for: indexPath) as? MovieDetailCreditCell
        else { return UICollectionViewCell() }

        let sectionType = Section.allCases[indexPath.section]

        switch sectionType {
        case .detail:
            guard let image = movie.posterImage else { return firstSectionCell }
            guard let movieDetail else { return firstSectionCell }
            firstSectionCell.configure(with: movieDetail, image: image)
            return firstSectionCell
        case .credit:
            creditCell.configure(with: movieCredits[indexPath.row])
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
        switch kind {
        case MovieDetailViewController.movieDetailSectionHeaderKind:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieDetailHeaderView.identifier,
                for: indexPath
            )
            return header
        default:
            return UICollectionReusableView()
        }
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
        DispatchQueue.main.async {
            self.movieDetailCollectionView.reloadData()
        }
    }

}

extension MovieDetailViewController {

    private func fetchMovieDetails() {
        guard let movieID = movie.ID else { return }
        let movieDetailEndPoint = MovieDetailsAPIEndPoint(movieCode: movieID)
        Task {
            do {
                let decodedData = try await movieNetworkAPIManager.fetchData(
                    to: MovieDetailsDTO.self,
                    endPoint: movieDetailEndPoint
                )
                guard let movie = decodedData as? MovieDetailsDTO else { return }
                movieDetail = movie
                DispatchQueue.main.async {
                    self.movieDetailCollectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    private func fetchMovieCredits() {
        guard let movieID = movie.ID else { return }
        let movieCreditsEndPoint = MovieCreditsAPIEndPoint(movieCode: movieID)
        // 💥 아래 로직 깔끔하게 정리하기!~~ + Popularity로 정렬하는 알고리즘 추가하자!!
        Task {
            do {
                let decodedData = try await movieNetworkAPIManager.fetchData(to: MovieCreditsDTO.self, endPoint: movieCreditsEndPoint)

                guard let credits = decodedData as? MovieCreditsDTO else { return }
                let group = credits.cast.sorted { first, second in
                    return first.popularity > second.popularity
                }
                for (index, actorInformation) in group.prefix(16).enumerated() {
                    guard let imageProfilePath = actorInformation.profilePath else { continue }
                    let imageProfilePathEndPoint = MovieImageAPIEndPoint(imageURL: imageProfilePath)
                    let actorName = actorInformation.name
                    let actorDepartment = actorInformation.department
                    let actorImageResult = try await movieNetworkDispatcher.performRequest(imageProfilePathEndPoint.urlRequest)
                    switch actorImageResult {
                    case .success(let data):
                        guard let profileImage = UIImage(data: data) else { return }
                        movieCredits[index].name = actorName
                        movieCredits[index].department = actorDepartment
                        movieCredits[index].profileImage = profileImage
                        movieCredits.append(MovieCredit(name: actorName, department: actorDepartment, profileImage: profileImage))
                    case .failure(let error):
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.movieDetailCollectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

}
