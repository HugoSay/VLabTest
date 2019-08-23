//
//  CommentViewModelTests.swift
//  VLabsTestTests
//
//  Created by Hugo Saynac on 23/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import XCTest
@testable import VLabsTest
import Moya
import RxSwift
import RxTest

enum DummyError: Error {
    case instance
}

class CommentViewModelTests: XCTestCase {
    var bag = DisposeBag()
    let post = Post(userID: 1, id: 1, title: "post", body: "post")

    func testFetchSuccess() {
        let comments = [Comment(postID: 1, id: 1, name: "test1", email: "email", body: "body")]
        let successFetcher = { Observable.just(comments) }
        let viewModel = CommentsViewModel(post: post, fetcher: successFetcher, postComment: {_ in .never()})

        let scheduler = TestScheduler(initialClock: 0)

        let res = scheduler.start {
            viewModel.comments
        }

        XCTAssertEqual(res.events, [
            .next(200, comments)
            ])
    }

    func testCreateNewCommentSuccess() {
        let comment = Comment(postID: 1, id: 1, name: "test1", email: "email", body: "body")
        let newComment = Comment(postID: 2, id: 2, name: "test2", email: "", body: "")

        let successFetcher = { Observable.just([comment]) }

        let viewModel = CommentsViewModel(post: post, fetcher: successFetcher, postComment: { _ in .just(newComment) })

        var res = [[Comment]]()

        viewModel.comments.subscribe(onNext: { (comments) in
            res.append(comments)
        }).disposed(by: bag)

        let commentBody = "Created Comment"
        viewModel.newComment.onNext("Created Comment")

        XCTAssertEqual(res, [[comment],
                             [comment, CommentsViewModel.comment(from: post, body: commentBody)],
                             [comment, newComment]])
    }

    func testCreateNewCommentError() {
        let comment = Comment(postID: 1, id: 1, name: "test1", email: "email", body: "body")

        let successFetcher = { Observable.just([comment]) }

        let viewModel = CommentsViewModel(post: post, fetcher: successFetcher, postComment: { _ in Observable.error(DummyError.instance) })

        var res = [[Comment]]()

        viewModel.comments.subscribe(onNext: { (comments) in
            res.append(comments)
        }).disposed(by: bag)

        viewModel.newComment.onNext("test")
        // when receiving an error display the last info received
        XCTAssertEqual(res, [[comment],
                             [comment, CommentsViewModel.comment(from: post, body: "test")],
                             [comment]])
    }
}
