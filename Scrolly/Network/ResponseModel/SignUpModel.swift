//
//  SigninModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation


struct SignUpModel: Decodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let message: String?
}

