//
//  MyProfileModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation

struct MyProfileModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let posts: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email, nick, phoneNum, birthDay, profileImage, posts
    }
}
