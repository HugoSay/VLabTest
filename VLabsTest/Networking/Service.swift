//
//  Service.swift
//  VLabsTest
//
//  Created by Hugo Saynac on 23/08/2019.
//  Copyright © 2019 HugoCorp. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum JsonPlaceholder {
    case users
    case posts(userId: Int)
    case albums(userId: Int)
    case photos(albumId: Int)
    case comments(postId: Int)
    case newComment(Comment) // On new comment I chose to send a simple Comment object with an id of -1 as an implementation shortcut.
    case image(URL)
}

extension JsonPlaceholder: TargetType {
    var baseURL: URL {
        switch self {
        case .image(let url):
            return url
        default:
            return URL(string: "https://jsonplaceholder.typicode.com")!
        }

    }

    var path: String {
        switch self {
        case .users:
            return "users"
        case .posts:
            return "posts"
        case .comments:
            return "comments"
        case .newComment(let comment):
            return "posts/\(comment.postID)/comments"
        case .albums:
            return "albums"
        case .photos:
            return "photos"
        case .image:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .newComment:
            return .post
        case .users, .posts, .comments, .albums, .photos, .image:
            return .get
        }
    }

    var sampleData: Data {
        fatalError("No sample data for now")
    }

    var task: Task {
        switch self {
        case .users, .image:
            return .requestPlain
        case .posts(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .comments(let postId):
            return .requestParameters(parameters: ["postId": postId], encoding: URLEncoding.queryString)
        case .newComment(let comment):
            return .requestJSONEncodable(comment)
        case .albums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .photos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
