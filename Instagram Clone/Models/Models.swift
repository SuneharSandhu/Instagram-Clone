//
//  Models.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/17/21.
//

import Foundation

/* Organize models later */

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

enum Gender {
    case male
    case female
    case other
}

/// Represents a user post
public struct UserPost {
    let id: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL    // either a video url or full resolution photo
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUsers: [User]
    let owner: User
}

public struct User {
    let username: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birthday: Date
    let gender: Gender
    let bio: String
    let counts: UserCount
    let joinDate: Date
}

public struct PostComment {
    let id: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

public struct PostLike {
    let username: String
    let postID: String
}

public struct CommentLike {
    let username: String
    let commentID: String
}

public struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}
