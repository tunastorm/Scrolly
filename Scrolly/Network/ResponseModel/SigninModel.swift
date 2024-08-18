//
//  SigninModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation


struct SigninModel: Decodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}

