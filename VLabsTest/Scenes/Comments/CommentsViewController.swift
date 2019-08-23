//
//  CommentsViewController.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 25/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class CommentsViewController: UIViewController {
    let viewModel: CommentsViewModel
    let bag = DisposeBag()
    let tableView = UITableView(frame: .zero, style: .plain)
    let refreshControl = UIRefreshControl()

    // MARK: - Comment entry properties

    let commentEntry = CommentEntryViewController.fromStoryboard()
    let commentEntryContainer = UIView()
    var bottomConstraint: NSLayoutConstraint?

    // MARK: - Life cycle

    init(viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        tableView.refreshControl = refreshControl

        super.init(nibName: nil, bundle: nil)
        tableView.register(CommentCell.self)
        self.title = "Comments"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviewAndFit(tableView)

        setupUI()
        setupKeyboardInteractions()
        bindViewModel()

    }

    // MARK: - Data binding

    func bindViewModel() {
        // Refresh control management
        refreshControl.rx.controlEvent(.allEvents).bind(to: viewModel.shouldRefresh).disposed(by: bag)
        viewModel.comments.map { _ in false }.bind(to: refreshControl.rx.isRefreshing).disposed(by: bag)

        // TableView binding
        viewModel.comments
            .bind(to: tableView.rx.items(cellIdentifier: CommentCell.reuseIdentifier, cellType: CommentCell.self)) { (_, comment, cell) in
                cell.textLabel?.text = comment.name
                cell.detailTextLabel?.text = comment.body

            }.disposed(by: bag)

        // Comment entry binding
        commentEntry.commentPublisher
            .bind(to: viewModel.newComment)
            .disposed(by: bag)
    }

    // MARK: - View Management

    private func setupKeyboardInteractions() {
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] height in
            guard let self = self else { return }

            self.bottomConstraint?.constant = -(height)
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.view.frame.maxY - self.commentEntryContainer.frame.minY, right: 0)
                self.tableView.scrollRectToVisible(self.tableView.visibleCells.last?.frame ?? .zero, animated: true)
            })

        }).disposed(by: bag)
    }

    private func setupUI() {
        tableView.tableFooterView = UIView()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        commentEntryContainer.addSubviewAndFit(blurView)

        view.addSubview(commentEntryContainer)

        addChild(commentEntry)

        tableView.keyboardDismissMode = .interactive
        commentEntryContainer.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor)
        bottomConstraint = commentEntryContainer.anchor(bottom: view.bottomAnchor).first

        commentEntryContainer.addSubview(commentEntry.view)
        commentEntry.view.anchor(top: commentEntryContainer.topAnchor, topConstant: 8,
                                 leading: commentEntryContainer.leadingAnchor, leadingConstant: 8,
                                 trailing: commentEntryContainer.trailingAnchor, trailingConstant: 8)

        let commentEntryBottomConstraint = commentEntry.view.bottomAnchor.constraint(equalTo: commentEntryContainer.bottomAnchor, constant: -8)
        commentEntryBottomConstraint.priority = .defaultHigh
        commentEntryBottomConstraint.isActive = true

        commentEntry.view.bottomAnchor.constraint(lessThanOrEqualTo: view.safeBottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }
}
