//
//  MovieDetailFirstSectionView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import UIKit

class MovieDetailFirstSectionView: UIView {

    private lazy var moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Dream")
        return imageView
    }()

    private let certificationLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 15
        label.textAlignment = .center

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.text = "-"

        return label
    }()

    private let englishTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "-"

        return label
    }()

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "-"
        label.textAlignment = .left

        return label
    }()

    private let tagLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.text = "-!"

        return label
    }()

    let overViewLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textColor = .lightGray

        return label
    }()

    private lazy var viewMoreButton: ViewMoreButton = {
        let button = ViewMoreButton()
        button.addTarget(self, action: #selector(moreButtonDidTapped), for: .touchUpInside)

        return button
    }()

    private lazy var movieTitleVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                englishTitleLabel,
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5

        return stackView
    }()

    private lazy var movieOverviewVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                tagLineLabel,
                overViewLabel,
                viewMoreButton
            ]
        )
        stackView.spacing = 10
        stackView.axis = .vertical

        return stackView
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let colors: [CGColor] = [.init(gray: 0.0, alpha: 0.5), .init(gray: 0.0, alpha: 1)]
        layer.locations = [0.25, 0.7]
        layer.colors = colors

        return layer
    }()

    weak var delegate: MovieDetailFirstSectionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    // 요거 다시 공부하기
    override func layoutSubviews() {
        super.layoutSubviews()
        configureMoviePosterImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(moviePosterImageView)
        addSubview(certificationLabel)
        addSubview(movieTitleVerticalStackView)
        addSubview(informationLabel)
        addSubview(movieOverviewVerticalStackView)

        moviePosterImageView.layer.addSublayer(gradientLayer)
        moviePosterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(600)
        }
        
        certificationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(moviePosterImageView.snp.centerY)
            $0.height.equalTo(30)
        }

        movieTitleVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(certificationLabel.snp.bottom).offset(15)
        }

        informationLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(movieTitleVerticalStackView.snp.bottom).offset(20)
        }

        movieOverviewVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(informationLabel.snp.bottom).offset(25)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        viewMoreButton.snp.makeConstraints {
            $0.height.equalTo(movieTitleVerticalStackView.snp.height)
        }
    }

    private func configureMoviePosterImageView() {
        gradientLayer.frame = moviePosterImageView.bounds
    }

    func configure(with movie: MovieDetail, image: UIImage) {
        self.moviePosterImageView.image = image
        self.titleLabel.text = movie.koreanTitle
        self.englishTitleLabel.text = movie.originalTitle
        self.informationLabel.text  = generateInformationText(
            releaseDate: movie.releaseDate,
            countries: movie.countries,
            kinds: movie.genres,
            runTime: movie.runtime
        )
        self.tagLineLabel.text = movie.tagLine
        self.overViewLabel.text = movie.overview
        configureCerticationLabel(rate: movie.certificationRate)
    }

    @objc private func moreButtonDidTapped(_ sender: UIButton) {
        delegate?.movieDetailFirstSectionView(self, didButtonTapped: sender)
    }

    private func configureCerticationLabel(rate: String) {
        guard let koreanRate = USACertifcation(rawValue: rate) else { return }
        certificationLabel.text = koreanRate.koreanDescription

        switch koreanRate {
        case .R, .NC17:
            certificationLabel.textColor = .red
            certificationLabel.layer.borderColor = UIColor.red.cgColor
        case .PG, .G:
            certificationLabel.textColor = .green
            certificationLabel.layer.borderColor = UIColor.green.cgColor
        case .NR:
            certificationLabel.textColor = .gray
            certificationLabel.layer.borderColor = UIColor.gray.cgColor
        case .PG13:
            certificationLabel.textColor = .yellow
            certificationLabel.layer.borderColor = UIColor.yellow.cgColor
        }
    }

    private func generateInformationText(
        releaseDate: String,
        countries: [ProductionCountry],
        kinds: [MovieKind],
        runTime: Int
    ) -> String {
        let verticalBar = "   ⃓  "
        let releaseDateString = releaseDate.replacingOccurrences(of: "-", with: ".")
        let countryNameString = countries.first?.name ?? ""
        let genreNameString = kinds.first?.name ?? ""
        let runTimeString = String(runTime)+"분"

        return releaseDateString + verticalBar + countryNameString + verticalBar + genreNameString + verticalBar + runTimeString
    }

}
