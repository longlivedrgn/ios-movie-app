//
//  DiskStorage.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/08.
//

import UIKit

struct DiskStorage {

    let fileManager = FileManager.default
    let directoryURL: URL

    init() {
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentURL.appendingPathComponent("DiskDirectory", isDirectory: true)
        self.directoryURL = directoryURL
        prepareDirectory()
    }

    func isCached(forkey key: String) -> Bool {
        let fileName = key
        let fileURL = directoryURL.appendingPathComponent(fileName)
        let filePath = fileURL.path
        guard FileManager.default.fileExists(atPath: filePath) else { return false }

        return true
    }

    func value(forKey key: String) -> UIImage {
        let fileURL = cacheFileURL(forKey: key)

        do {
            let data = try Data(contentsOf: fileURL)
            let image = UIImage(data: data) ?? UIImage()
            return image
        } catch {
            return UIImage()
        }
    }

    func store(image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        let fileURL = cacheFileURL(forKey: key)
        do {
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }

    private func cacheFileURL(forKey key: String) -> URL {
        return directoryURL.appendingPathComponent(key, isDirectory: false)
    }

    private func prepareDirectory() {
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }

}
