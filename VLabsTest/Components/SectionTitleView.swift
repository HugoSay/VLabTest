//
//  SectionTitleView.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
    let label: UILabel

    override init(frame: CGRect) {
        label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)

        super.init(frame: .zero)

        backgroundColor = .groupTableViewBackground
        addSubview(label)
        label.anchor(top: safeTopAnchor,
                     bottom: safeBottomAnchor,
                     leading: safeLeadingAnchor, leadingConstant: 12,
                     trailing: safeTrailingAnchor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.zPosition = 0
    }
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }
}
