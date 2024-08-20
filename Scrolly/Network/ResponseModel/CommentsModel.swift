//
//  UploadCommentsModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import Foundation

struct CommentsModel: Decodable {
    
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
        case message
    }
    
}
