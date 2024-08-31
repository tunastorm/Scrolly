//
//  PaymentValidationQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/30/24.
//

import Foundation

struct PaymentValidationQuery: Encodable {
    
    let impUid: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case postId = "post_id"
    }

}
