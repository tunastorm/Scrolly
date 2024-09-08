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
    
    @UserDefaultWrapper(key: APIConstants.nickname)
    static var nick: String
    
    @UserDefaultWrapper(key: APIConstants.user)
    static var user: String
    
    @UserDefaultWrapper(key: APIConstants.email)
    static var email: String
    
    @UserDefaultWrapper(key: APIConstants.profile)
    static var profile: String

}

@propertyWrapper
struct UserDefaultWrapper {
  
    private let key: String
//    private let defaultValue: T?
    
    init(key: String) {
        self.key = key
//        self.defaultValue = defaultValue
    }
    
    var wrappedValue: String {
        get {
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
    
//    var wrappedValue: T? {
//        get {
//            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
//                let decoder = JSONDecoder()
//                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
//                    return lodedObejct
//                }
//            }
//            return defaultValue
//        }
//        set {
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(newValue) {
//                UserDefaults.standard.setValue(encoded, forKey: key)
//            }
//        }
//    }
}

