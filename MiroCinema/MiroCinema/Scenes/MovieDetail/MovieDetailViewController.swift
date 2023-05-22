//
//  MovieDetailViewController.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie?
    private let networkAPIManager: NetworkAPIManager

    init(movie: Movie, networkAPIManager: NetworkAPIManager) {
        self.movie = movie
        self.networkAPIManager = networkAPIManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
