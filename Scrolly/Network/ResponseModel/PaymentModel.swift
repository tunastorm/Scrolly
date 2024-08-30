//
//  PaymentValidationModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/30/24.
//

import Foundation

struct PaymentModel: Decodable {
    let buyerId: String
    let postId: String
    let merchantUid: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantUid = "merchant_uid"
        case productName = "productName"
        case price, paidAt
    }
}
