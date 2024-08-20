//
//  GetPostsModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import Foundation

struct GetPostsModel: Decodable {
    
    let data: [PostsModel]
    let nextCursor: String
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
        case message
    }
    
}
