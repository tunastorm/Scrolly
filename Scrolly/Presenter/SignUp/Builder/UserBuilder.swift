//
//  UserBuilder.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation

final class UserBuilder {
    
    private var user = SignUpQuery(email: "", password: "", nick: "")
    
    func withEmail(_ email: String) -> Self {
        user.email = email
        return self
    }
    
    func withPassword(_ password: String) -> Self {
        user.password = password
        return self
    }
    
    func withNickname(_ nickname: String) -> Self {
        user.nick = nickname
        return self
    }
    
    func withPhone(_ phone: String) -> Self {
        user.phoneNum = phone
        return self
    }
    
    func withBirthday(_ birthDay: String) -> Self {
        user.birthDay = birthDay
        return self
    }
    
    func build() -> SignUpQuery {
        return user
    }
    
}


