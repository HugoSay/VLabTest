//
//  CommentCell.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 26/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0

    }
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }
}
