//
//  USACertification.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

enum USACertifcation: String {

    case R = "R"
    case PG = "PG"
    case NC17 = "NC-17"
    case G = "G"
    case NR = "NR"
    case PG13 = "PG-13"

    var koreanDescription: String {
        switch self {
        case .R:
            return "청소년 관람 불가"
        case .PG:
            return "전체 관람가"
        case .NC17:
            return "청소년 관람 불가"
        case .G:
            return "전체 관람가"
        case .NR:
            return "상영 등급 미지정"
        case .PG13:
            return "15세이상 관람가"
        }
    }

}
