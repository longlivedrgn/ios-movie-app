//
//  UICollectionView+.swift
//  MiroCinema
//
//  Created by 김용재 on 2023/06/08.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(supplementaryView: T.Type, kind: String) {
        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier
        )
    }

    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.reuseIdentifier, for: indexPath) as! T
    }

    func dequeue<T: UICollectionReusableView>(supplementaryView: T.Type, for indexPath: IndexPath, kind: String) -> T {
        return dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: supplementaryView.reuseIdentifier,
            for: indexPath) as! T
    }

}
