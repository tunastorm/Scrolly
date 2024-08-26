//
//  UserDefaultsManager.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation

struct UserDefaultsManager {
    
    @UserDefaultWrapper(key: APIConstants.token)
    static var token: String
    
    @UserDefaultWrapper(key: APIConstants.refresh)
    static var refresh: String

}

@propertyWrapper
struct UserDefaultWrapper {
  
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: String {
        get {
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

