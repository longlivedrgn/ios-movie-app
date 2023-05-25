//
//  MovieRankHeaderView.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/18.
//

import UIKit

class MovieRankHeaderView: UICollectionReusableView {

    static let identifier = String(describing: MovieRankHeaderView.self)

    private let containerView: UIView = {
        let view = UIView()

        return view
    }()

    private lazy var sortedByOpenDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("영화 개봉순", for: .normal)
        button.addTarget(self, action: #selector(sortedByOpenDateButtonDidTapped), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 1
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.gray.cgColor
        button.tag = SortedByButton.openDate.rawValue

        return button
    }()

    private lazy var sortedByReservationRateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sortedByReservationRateButtonDidTapped), for: .touchUpInside)
        button.setTitle("예매율순", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = UIColor(red: 0.902, green: 0.286, blue: 0.502, alpha: 1)
        button.tag = SortedByButton.reservationRate.rawValue

        return button
    }()

    private lazy var movieRankHorizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [sortedByReservationRateButton, sortedByOpenDateButton]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillProportionally

        return stackView
    }()

    weak var delegate: MovieRankHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(containerView)
        containerView.addSubview(movieRankHorizontalStackView)
        movieRankHorizontalStackView.addSubview(sortedByOpenDateButton)
        movieRankHorizontalStackView.addSubview(sortedByReservationRateButton)
    }

    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.top.bottom.equalToSuperview()
        }

        movieRankHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func changeButtonColor(clickedButton button: UIButton) {
        switch SortedByButton(rawValue: button.tag) {
        case .reservationRate:
            sortedByReservationRateButton.backgroundColor = UIColor(red: 0.902, green: 0.286, blue: 0.502, alpha: 1)
            sortedByReservationRateButton.layer.borderWidth = 0
            sortedByOpenDateButton.layer.borderWidth = 1
            sortedByOpenDateButton.backgroundColor = .black
            sortedByOpenDateButton.layer.borderColor = UIColor.gray.cgColor
        case .openDate:
            sortedByOpenDateButton.backgroundColor = UIColor(red: 0.902, green: 0.286, blue: 0.502, alpha: 1)
            sortedByOpenDateButton.layer.borderWidth = 0
            sortedByReservationRateButton.layer.borderWidth = 1
            sortedByReservationRateButton.backgroundColor = .black
            sortedByReservationRateButton.layer.borderColor = UIColor.gray.cgColor
        case .none:
            fatalError()
        }
    }

    @objc private func sortedByOpenDateButtonDidTapped(_ sender: UIButton) {
        delegate?.movieRankHeaderView(self, didButtonTapped: sender)
    }

    @objc private func sortedByReservationRateButtonDidTapped(_ sender: UIButton) {
        delegate?.movieRankHeaderView(self, didButtonTapped: sender)
    }

}
