//
//  String+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/25.
//

import Foundation

extension String {

    func convertToDate() -> Date {
        guard let date = DateFormatter.yearMonthDateWithDash.date(from: self) else { return Date() }
        return date
    }

}
