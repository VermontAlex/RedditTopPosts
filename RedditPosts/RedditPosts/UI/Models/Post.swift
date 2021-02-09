//
//  Post.swift
//  RedditPosts
//
//  Created by Oleksandr Oliynyk on 08.02.2021.
//

import Foundation



// MARK: - Post
struct Post: Codable {
    let kind: String
    let data: PostData
}

// MARK: - PostData
struct PostData: Codable {
    let modhash: String
    let dist: Int
    let children: [Child]
}

// MARK: - Child
struct Child: Codable {
    let kind: String
    let data: ChildData
}

// MARK: - ChildData
struct ChildData: Codable {
    let author, title: String
    //High quality for PostImage
    let url_overridden_by_dest: String
    
    
    
//MARK: If you want use your own name for JSON porperties, you must use CodingKey which
//MARK: replaces words needed.
//    enum CodingKeys: String, CodingKey {
//        case author = "author"
//        case title
//    }
}


