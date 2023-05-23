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

    private let certificationView: UIView = {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)

        label.text = "전체 관람가"
        label.font = UIFont.systemFont(ofSize: 10)

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .systemBackground
        label.text = "슈퍼 마리오 브라더스"

        return label
    }()

    private let englishTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "The Super Mario Bros"

        return label
    }()

    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.text = "2023.04.26"

        return label
    }()

    private let tagLineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemBackground
        label.text = "동생을 구하기 위해! 세상을 지키기 위해! '슈퍼 마리오'로 레벨업하기 위한 '마리오'의 스펙터클한 스테이지가 시작된다!"

        return label
    }()

    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.text = "따단-딴-따단-딴 ♫ 전 세계를 열광시킬 올 타임 슈퍼 어드벤처의 등장! 뉴욕의 평범한 배관공 형제 '마리오'와 ‘루이지’는 배수관 고장으로 위기에 빠진 도시를 구하려다 미스터리한 초록색 파이프 안으로 빨려 들어가게 된다. 파이프를 통해 새로운 세상으로 차원 이동하게 된 형제. 형 '마리오'는 뛰어난 리더십을 지닌 '피치'가 통치하는 버섯왕국에 도착하지만 동생 '루이지'는 빌런 '쿠파'가 있는 다크랜드로 떨어지며 납치를 당하고 ‘마리오’는 동생을 구하기 위해 ‘피치’와 ‘키노피오’의 도움을 받아 '쿠파'에 맞서기로 결심한다. 그러나 슈퍼스타로 세상을 지배하려는 그의 강력한 힘 앞에 이들은 예기치 못한 위험에 빠지게 되는데"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray

        return label
    }()
    // 요거 home view에서 사용하니까 따로 빼기!!
    private let moreButton: UIButton = {
        let button = UIButton()
        let buttonTitleColor = UIColor.white
        let symbolImage = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        let buttonTitle = NSMutableAttributedString(string: "더보기 ")
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = symbolImage
        let symbolString = NSAttributedString(attachment: symbolAttachment)
        buttonTitle.append(symbolString)
        buttonTitle.addAttribute(.foregroundColor, value: buttonTitleColor, range: NSRange(location: 0, length: buttonTitle.length))
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10

        return button
    }()

    private lazy var movieDetailVerticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                certificationView,
                titleLabel,
                englishTitleLabel,
                informationLabel,
                tagLineLabel,
                overViewLabel,
                moreButton
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally

        return stackView
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let colors: [CGColor] = [.init(gray: 0.0, alpha: 0.5), .init(gray: 0.0, alpha: 1)]
        layer.locations = [0.25, 0.7]
        layer.colors = colors

        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    // 요거 다시 공부하기
    override func layoutSubviews() {
        super.layoutSubviews()
        configureMoviePosterImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        addSubview(moviePosterImageView)
        addSubview(movieDetailVerticalStackView)
        moviePosterImageView.layer.addSublayer(gradientLayer)

        moviePosterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.height)
        }
        
        movieDetailVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(moviePosterImageView.snp.centerY)
        }
    }

    private func configureMoviePosterImageView() {
        gradientLayer.frame = moviePosterImageView.bounds
    }

}