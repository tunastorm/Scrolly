//
//  LikeModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import Foundation

struct LikeModel: Decodable {
    let titleStatus: Bool
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case titleStatus = "like_status"
        case message
    }
}
