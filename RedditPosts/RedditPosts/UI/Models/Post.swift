//
//  Post.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import Foundation

struct Post: Codable {
    let data: PostData
}
struct PostData: Codable {
    let modhash: String
    let dist: Int
    let after: String?
    let children: [Child]
}
struct Child: Codable {
    let data: ChildData
}
// MARK: - ChildData - is an post from Top Posts
struct ChildData: Codable {
    let author, title: String
    //url which upload just images from post
    let url: String
    let thumbnail: String
    let num_comments: Int
    let created_utc: Double? //TODO: names with '_' are not good in Swift. Please use JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    let post_hint: String? //TODO: should it be enum? what cases possible?
}
