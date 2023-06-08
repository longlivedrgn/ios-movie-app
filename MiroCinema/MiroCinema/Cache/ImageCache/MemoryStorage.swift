//
//  MemoryStorage.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/08.
//

import UIKit

struct MemoryStorage {

    private let storage = NSCache<NSString, UIImage>()

    func store(image: UIImage, forKey key: String) {
        storage.setObject(image, forKey: key as NSString)
    }

    func value(forKey key: String) -> UIImage? {
        guard let object = storage.object(forKey: key as NSString) else { return nil }

        return object
    }

    func isCached(forKey key: String) -> Bool {
        guard let _ = value(forKey: key) else { return false }

        return true
    }

}
