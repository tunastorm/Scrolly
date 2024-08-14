//
//  SigninQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation

struct SigninQuery: Encodable {
    
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    
}
