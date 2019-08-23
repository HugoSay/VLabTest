//
//  UserViewController.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 23/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import RxCocoa
import UIKit
import RxSwift
import RxDataSources
import Moya
class AlbumsCell: UICollectionViewCell {}

class UserViewController: ViewController, UICollectionViewDelegateFlowLayout {
    let viewModel: UserViewModel
    let collectionView: UICollectionView
    var albumsViewController: AlbumsViewController?

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UserLayout())

        super.init(nibName: nil, bundle: nil)

        self.title = viewModel.user.username
        view.addSubviewAndFit(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(AlbumsCell.self)
        collectionView.register(PostCollectionViewCell.self)
        collectionView.register(SectionTitleView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionTitleView")

    }

    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()

        collectionView.rx.modelSelected(ItemType.self).bind { [weak self] item in
            switch item {
            case .album:
                break
            case .post(let post):
                self?.showCommentsViewController(for: post)
            }
            }.disposed(by: bag)
    }

    func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<UserSection> (
            configureCell: { [unowned self] (dataSource, collectionView, indexPath, section) -> UICollectionViewCell in
                switch section {
                case .album(let albums):
                    return self.albumCell(collectionView, indexPath, albums)
                case .post(let post):
                    return self.postCell(collectionView, indexPath, post)
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let section = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: "SectionTitleView",
                                                      for: indexPath) as! SectionTitleView
                section.label.text = dataSource[indexPath.section].title

                return section
        })

        viewModel.sections.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }

    fileprivate func albumCell(_ collectionView: UICollectionView,
                               _ indexPath: IndexPath,
                               _ albums: ([Album])) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumsCell.reuseIdentifier, for: indexPath)
        if albumsViewController == nil {
            let albumsViewController = AlbumsViewController(albums: albums, layout: albumLayout)
            self.albumsViewController = albumsViewController
            addChild(albumsViewController)

            cell.contentView.addSubviewAndFit(albumsViewController.view)
            albumsViewController.view.anchor(height: 200)
        }
        return cell
    }

    fileprivate func postCell(_ collectionView: UICollectionView,
                              _ indexPath: IndexPath,
                              _ post: (Post)) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! PostCollectionViewCell
        cell.configure(with: post)

        return cell
    }

    func showCommentsViewController(for post: Post) {
        let viewModel = CommentsViewModel(post: post,
                                          fetcher: { Network.comments(for: post.id).asObservable() },
                                          postComment: { comment in
                                            Network.createComment(comment)
                                                .asObservable()
        })

        let viewController = CommentsViewController(viewModel: viewModel)
        show(viewController, sender: self)
    }

    // Handle screen rotations
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        albumsViewController?.view.anchor(width: size.width)
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}

private let albumLayout: UICollectionViewLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    layout.estimatedItemSize = CGSize(width: 150, height: 200)
    return layout
}()
