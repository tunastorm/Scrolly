//
//  UploadPostsModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/19/24.
//

import Foundation

struct PostsModel: Decodable, Hashable {
    let postId: String
    let productId: String
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [Comment]
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title, content, content1, content2, content3, content4, content5,
             createdAt, creator, files, likes, likes2, hashTags, comments
        case message
    }
    
    init() {
        self.postId = "blanck"
        self.productId = "blacnkProduct"
        self.title = nil
        self.content = nil
        self.content1 = nil
        self.content2 = nil
        self.content3 = nil
        self.content4 = nil
        self.content5 = nil
        self.createdAt = ""
        self.creator = Creator()
        self.files = []
        self.likes = []
        self.likes2 = []
        self.hashTags = []
        self.comments = []
        self.message = nil
        
    }
    
}

struct Creator: Decodable, Hashable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
    
    init() {
        self.userId = ""
        self.nick = ""
        self.profileImage = nil
    }
}

struct Comment: Decodable, Hashable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
    }
}
