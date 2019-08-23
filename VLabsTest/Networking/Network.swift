//
//  Network.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum Network {
    private static let network = MoyaProvider<JsonPlaceholder>()
    static func users() -> Single<[User]> {
        return network.rx.request(.users).map([User].self)
    }

    static func posts(for userId: Int) -> Single<[Post]> {
        return network.rx.request(.posts(userId: userId)).map([Post].self)
    }

    static func comments(for postId: Int) -> Single<[Comment]> {
        return network.rx.request(.comments(postId: postId)).map([Comment].self)
    }

    static func createComment(_ comment: Comment) -> Single<Comment> {
        return network.rx.request(.newComment(comment)).map(Comment.self)
    }

    static func photos(for albumId: Int) -> Single<[Photo]> {
        return network.rx.request(.photos(albumId: albumId)).map([Photo].self)
    }

    static func albums(for userId: Int) -> Single<[Album]> {
        return network.rx.request(.albums(userId: userId)).map([Album].self)
    }

    static func image(url: URL) -> Single<UIImage> {
        return network.rx.request(.image(url)).mapImage()
    }
}
