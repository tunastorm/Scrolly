//
//  WithDrawModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation


struct WithDrawModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email, nick
    }
}
