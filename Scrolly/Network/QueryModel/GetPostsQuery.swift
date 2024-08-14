//
//  getPostQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation

struct GetPostsQuery: Encodable {
    
    let next: String?
    let limit: String?
    let productId: String?
    
}
