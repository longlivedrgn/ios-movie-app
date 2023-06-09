//
//  MovieSearchViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

class MovieSearchViewController: UIViewController {

    private let movieNetworkAPIManager = NetworkAPIManager()
    private let movieNetworkDispatcher = NetworkDispatcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
    }

    private func configureView() {
        view.backgroundColor = .green
    }

    private func configureSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "작품의 제목을 검색해보세요"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

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
