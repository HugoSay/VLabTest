//
//  UITableView+Extensions.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 26/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return (Bundle(for: self).bundleIdentifier ?? "") + String(describing: self)
    }
}
