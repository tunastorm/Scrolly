//
//  MyProfileQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/15/24.
//

import Foundation


struct MyProfileQuery: Encodable {
    
    let nick: String?
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
    
}
