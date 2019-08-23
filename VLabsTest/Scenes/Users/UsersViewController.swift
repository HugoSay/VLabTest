//
//  ViewController.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 23/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import RxCocoa

/// ListViewController with no view model instanciated from storyboard
class UsersViewController: ViewController {
    @IBOutlet weak private var tableView: UITableView!
    private let reloadData = PublishRelay<Void>()

    lazy var users: Driver<[User]> = reloadData.asObservable()
        .startWith(())
        .flatMap(Network.users)
        .asDriver(onErrorJustReturn: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        bindTableview()
        setupPullToRefresh()
    }

    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        // Trigger refresh when pulling view
        refreshControl.rx.controlEvent(.valueChanged).bind(to: reloadData).disposed(by: bag)

        // hide refreshcontroll when receiving results
        users.map { _ in false }.drive(refreshControl.rx.isRefreshing).disposed(by: bag)
    }

    func bindTableview() {
        users.drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, user, cell) in
                cell.textLabel?.text = user.username
                cell.accessoryType = .disclosureIndicator

            }.disposed(by: bag)

        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [unowned self] user in
                let userInfoFetcher = UserInfoFetcher(
                    fetchAlbums: { Network.albums(for: user.id) },
                    fetchPosts: { Network.posts(for: user.id) })

                let viewModel =  UserViewModel(user: user, fetcher: userInfoFetcher)
                let viewController = UserViewController(viewModel: viewModel)
                self.show(viewController, sender: self)
            })
            .disposed(by: bag)
    }
}
