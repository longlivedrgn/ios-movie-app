//
//  NSNotification+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/05.
//

import Foundation

extension NSNotification.Name {

    static let genreModelDidFetchData = Notification.Name("MovieGenreModelDidFetchData")
    static let detailModelDidFetchDetailData = Notification.Name("MovieDetailModelDidFetchDetailData")
    static let detailModelDidFetchCreditData = Notification.Name("MovieDetailModelDidFetchCreditData")
    static let homeModelDidFetchData = Notification.Name("MovieHomeModelDidFetchData")

}
