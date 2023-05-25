//
//  DateFormatter+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//

import Foundation

extension DateFormatter {

    static let yearMonthDateWithDash: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

}
