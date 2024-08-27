//
//  uploadPostsQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation

struct PostsQuery: Encodable {
    
    let productId: String?
    let title: String?
    let price: Int?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let files: [String]?
    // let price: String? 서버측 구현 예정
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title, price, content, content1, content2, content3, content4, content5, files
    }
    
}
