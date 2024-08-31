//
//  HashTagsQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation

struct HashTagsQuery: Encodable {
    let next: String?
    let limit: String?
    let productId: String?
    let hashTag: String?
    
    enum CodingKeys: String, CodingKey {
        case next, limit, hashTag
        case productId = "product_id"
    }
}
