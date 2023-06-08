//
//  ImageCacheManager.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/05/28.
//

import UIKit

final class ImageCacheManager  {

    static let shared = ImageCacheManager()

    private let diskStorage = DiskStorage()
    private let memoryStorage = MemoryStorage()

    enum Storage {
        case disk
        case memory
    }

    func isCached(resourceKey key: String) -> Bool {
        let cacheKey = cacheKey(of: key)
        guard memoryStorage.isCached(forKey: cacheKey) || diskStorage.isCached(forkey: cacheKey) else {
            return false
        }
        return true
    }

    private func cacheKey(of resourceKey: String) -> String {
        return resourceKey.components(separatedBy: ["/"]).last!
    }

    func store(image: UIImage, forResourceKey key: String, in storage: Storage) {
        let cacheKey = cacheKey(of: key)
        switch storage {
        case .disk :
            diskStorage.store(image: image, forKey: cacheKey)
        case .memory:
            memoryStorage.store(image: image, forKey: cacheKey)
        }
    }

    func value(forResoureceKey key: String) -> UIImage {
        let cacheKey = cacheKey(of: key)
        if memoryStorage.isCached(forKey: cacheKey) {
            return memoryStorage.value(forKey: cacheKey) ?? UIImage()
        } else {
            return diskStorage.value(forKey: cacheKey)
        }
    }

}
