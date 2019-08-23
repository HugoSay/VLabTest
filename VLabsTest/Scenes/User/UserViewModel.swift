//
//  UserViewModel.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 27/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum UserSection {
    case album(ItemType)
    case post([ItemType])

    var title: String {
        switch self {
        case .album:
            return "Albums"
        case .post:
            return "Posts"
        }
    }
}

extension UserSection: SectionModelType {
    init(original: UserSection, items: [ItemType]) {
        self = original
    }

    var items: [ItemType] {
        switch self {
        case .album(let item):
            return [item]
        case .post(let items):
            return items
        }
    }
}

enum ItemType {
    case album([Album])
    case post(Post)
}

struct UserInfoFetcher {
    let fetchAlbums: () -> Single<[Album]>
    let fetchPosts: () -> Single<[Post]>
}

class UserViewModel {
    let fetcher: UserInfoFetcher
    let user: User
    let sections: Observable<[UserSection]>

    init(user: User, fetcher: UserInfoFetcher) {
        self.user = user
        self.fetcher = fetcher

        let posts = fetcher.fetchPosts().asObservable()
            .map { $0.map(ItemType.post) }
            .map(UserSection.post)

        let albums = fetcher.fetchAlbums().asObservable()
            .map { UserSection.album(.album($0))}

        self.sections = Observable.combineLatest(albums, posts).map { [$0, $1] }
    }

}
