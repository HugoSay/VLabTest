//
//  AlbumCell.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class AlbumCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        label.text = "0"
        return label
    }()

    var bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        stackView.axis = .vertical
        contentView.addSubviewAndFit(stackView)

        stackView.addArrangedSubview(imageView)
        imageView.anchor(width: 150, height: 150)
        imageView.backgroundColor = UIColor.lightGray

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(numberLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with album: Album) {
        let photos = Network.photos(for: album.id).asObservable().share(replay: 1)

        photos
            .map { $0.first }
            .unwrap()
            .flatMap { $0.thumbnail }
            .asDriver(onErrorJustReturn: UIImage())
            .drive(imageView.rx.image)
            .disposed(by: bag)

        titleLabel.text = album.title

        photos.map { "\($0.count)" }
            .bind(to: numberLabel.rx.text)
            .disposed(by: bag)

    }

    override func prepareForReuse() {
        imageView.image = nil
        bag = DisposeBag()
    }
}
