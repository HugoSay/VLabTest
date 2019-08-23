//
//  AlbumsViewController.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 26/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxDataSources

struct AlbumSection {
    var items: [Album]
}

extension AlbumSection: SectionModelType {
    init(original: AlbumSection, items: [Album]) {
        self = original
        self.items = items
    }
}

class AlbumsViewController: ViewController {
    let collectionView: UICollectionView
    let albums: [Album]

    init(albums: [Album], layout: UICollectionViewLayout = AlbumsViewController.defaultLayout) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(AlbumCell.self)
        self.albums = albums

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubviewAndFit(collectionView)
        collectionView.backgroundColor = .white

        let dataSource = RxCollectionViewSectionedReloadDataSource<AlbumSection> (configureCell: { (_, collectionView, indexPath, album) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseIdentifier, for: indexPath) as! AlbumCell
            cell.configure(with: album)
            return cell
        })

        Observable<[AlbumSection]>.just([AlbumSection(items: albums)])
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

    }

    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }
}

extension AlbumsViewController {
    static var defaultLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 75, height: 75)
        return layout
    }()

}
