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

// MARK: - ChildData
struct ChildData: Codable {
    let author, title: String
//    let url: String
    let thumbnail: String
//    let url_overridden_by_dest: String
    let num_comments: Int
    let created_utc: Double?
//    let preview: Preview
}
//MARK: Data for subreddit images
//struct Preview: Codable{
//    let images: [SourceImages]
//}
//struct SourceImages: Codable {
//    let source: JSONImageSource
//}
//
//struct JSONImageSource: Codable {
//    let url: URL
//    let width: Int
//    let height: Int
//}
