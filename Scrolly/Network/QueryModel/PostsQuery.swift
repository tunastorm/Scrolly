//
//  uploadPostsQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation

struct PostsQuery: Encodable {
    
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let productId: String?
    let files: [String]?
    
}
