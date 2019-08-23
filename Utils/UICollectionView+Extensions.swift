//
//  UITableView+Extensions.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 26/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return (Bundle(for: self).bundleIdentifier ?? "") + String(describing: self)
    }
}
