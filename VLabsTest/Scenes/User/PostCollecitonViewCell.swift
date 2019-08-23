//
//  PostCollecitonViewCell.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    fileprivate func addSeparatorView() {
        let borderView = UIView()
        contentView.addSubview(borderView)
        borderView.anchor(bottom: contentView.safeBottomAnchor,
                          leading: contentView.safeLeadingAnchor, leadingConstant: 12,
                          trailing: contentView.safeTrailingAnchor,
                          height: 1 / UIScreen.main.scale)
        borderView.backgroundColor = .lightGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)

        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.safeLeadingAnchor, leadingConstant: 12,
                          trailing: contentView.safeTrailingAnchor, trailingConstant: 8)

        bodyLabel.anchor(top: titleLabel.bottomAnchor, bottom: contentView.bottomAnchor, bottomConstant: 8, leading: titleLabel.leadingAnchor, trailing: titleLabel.trailingAnchor)

        addSeparatorView()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttributes.bounds.size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return layoutAttributes
    }

    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }

    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }

}

class UserLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let width = collectionView.bounds.width

        self.estimatedItemSize = CGSize(width: width, height: 200)
        headerReferenceSize = CGSize(width: 100, height: 60)
    }
}
