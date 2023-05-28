//
//  ImageCacheManager.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

final class ImageCacheManager {

    static let shared = NSCache<NSString, UIImage>()
    private init() {}

}
