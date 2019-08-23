//
//  CommentsViewModel.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 26/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import RxSwift

enum CommentState {
    case createdComment(Comment)
    case newComment(Comment)
    case fetchedComments([Comment])
    case error
}

class CommentsViewModel {
    let bag = DisposeBag()
    let comments: Observable<[Comment]>

    let newComment = PublishSubject<String>()
    let shouldRefresh = PublishSubject<Void>()

    init(post: Post, fetcher: @escaping (() -> Observable<[Comment]>), postComment: @escaping (Comment) -> Observable<Comment>) {

        let createdComment = newComment.map { CommentsViewModel.comment(from: post, body: $0) }

        let newComment: Observable<Comment> = createdComment.flatMap(postComment)
        let comments: Observable<[Comment]> = shouldRefresh
            .startWith(()) // Trigger first load when creating the view model
            .flatMap(fetcher)

        self.comments = Observable.merge(comments.map(CommentState.fetchedComments),
                                          createdComment.map(CommentState.createdComment),
                                         newComment.map(CommentState.newComment))
            .catchErrorJustReturn(.error)
            .scan([Comment]()) { (oldValue, newValue) -> [Comment] in

                switch newValue {
                case .fetchedComments(let fetchedData):
                    return fetchedData // return the updated comments
                case .newComment(let newComment):
                    if let index = oldValue.firstIndex(where: { $0.id == -1 }) {
                        var newValue = oldValue
                        newValue[index] = newComment
                        return newValue
                    } else {
                        return oldValue + CollectionOfOne(newComment)
                    }
                 // add the new element to the list
                case .createdComment(let createdComment):
                    return oldValue + CollectionOfOne(createdComment)
                case .error:
                    return oldValue.filter { $0.id != -1} // return the last valid value removing created comments)
                }
        }
    }

    static func comment(from post: Post, body: String) -> Comment {
        return Comment(postID: post.id,
                       id: -1,
                       name: UIDevice.current.name,
                       email: "",
                       body: body)
    }
}
