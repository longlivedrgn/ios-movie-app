//
//  MovieSearchViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/09.
//

import UIKit

class MovieSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
    }

    private func configureView() {
        view.backgroundColor = .green
    }

    private func configureNavigationBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "작품의 제목을 검색해보세요"
        navigationItem.titleView = searchBar
    }

}
