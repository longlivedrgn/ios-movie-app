//
//  Genre.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/22.
//

import Foundation

enum Genre: Int {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case thriller = 53
    case war = 10752
    case western = 37

    var description: String {
        switch self {
        case .action:
            return "액션"
        case .adventure:
            return "어드벤쳐"
        case .animation:
            return "애니메이션"
        case .comedy:
            return "코미디"
        case .crime:
            return "범죄"
        case .documentary:
            return "다큐멘터리"
        case .drama:
            return "드라마"
        case .family:
            return "가족"
        case .fantasy:
            return "판타지"
        case .history:
            return "역사"
        case .horror:
            return "호러"
        case .music:
            return "음악"
        case .mystery:
            return "미스터리"
        case .romance:
            return "로맨스"
        case .scienceFiction:
            return "공상과학"
        case .thriller:
            return "스릴러"
        case .war:
            return "전쟁"
        case .western:
            return "서부극"
        }
    }
}
