//
//  Post.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import Foundation



// MARK: - Post
struct Post: Codable {
    let data: PostData
}

// MARK: - PostData
struct PostData: Codable {
    let modhash: String
    let dist: Int
    let after: String?
    let before: String?
    let children: [Child]
}

// MARK: - Child
struct Child: Codable {
    let data: ChildData
}

// MARK: - ChildData - is an post from Top Posts
struct ChildData: Codable {
    let author, title: String
    //url which upload just images from post
    let url: String
    //Image from thumbnail full size
//    let url_overridden_by_dest: String
    let num_comments: Int
    let created_utc: Double?
    let post_hint: String?
}
