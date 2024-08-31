//
//  SigninQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation

struct SignUpQuery: Encodable {
    
    var email: String
    var password: String
    var nick: String
    var phoneNum: String?
    var birthDay: String?
    
}
