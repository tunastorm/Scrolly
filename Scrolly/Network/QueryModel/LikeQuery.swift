//
//  LikeQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation

struct LikeQuery: Encodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
