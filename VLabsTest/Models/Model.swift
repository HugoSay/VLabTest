// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let comments = try? newJSONDecoder().decode(Comments.self, from: jsonData)
//   let posts = try? newJSONDecoder().decode(Posts.self, from: jsonData)
//   let users = try? newJSONDecoder().decode(Users.self, from: jsonData)
//   let albums = try? newJSONDecoder().decode(Albums.self, from: jsonData)
//   let photos = try? newJSONDecoder().decode(Photos.self, from: jsonData)
//   let createComment = try? newJSONDecoder().decode(CreateComment.self, from: jsonData)

import Foundation

// MARK: - Comment
struct Comment: Codable, Equatable {
    let postID: Int
    let id: Int
    let name: String
    let email: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id = "id"
        case name = "name"
        case email = "email"
        case body = "body"
    }
}

// MARK: - Post
struct Post: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }
}

// MARK: - Address
struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo

    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
        case geo = "geo"
    }
}

// MARK: - Geo
struct Geo: Codable {
    let lat: String
    let lng: String

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}

// MARK: - Company
struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }
}

// MARK: - Album
struct Album: Codable {
    let userID: Int
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id = "id"
        case title = "title"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let albumID: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailURL: URL

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailURL = "thumbnailUrl"
    }
}

/// create comment
///
/// POST https://jsonplaceholder.typicode.com/posts/1/comments
// MARK: - CreateComment
struct CreateComment: Codable {
    let postID: Int
    let name: String
    let email: String
    let body: String
    let postundefined: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case name = "name"
        case email = "email"
        case body = "body"
        case postundefined = "postundefined"
        case id = "id"
    }
}
