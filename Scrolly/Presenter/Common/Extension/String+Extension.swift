//
//  String+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation

extension String {
    
    func localized(str: String, number: Int) -> String {
        return  String(format: self.localized, str, number)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}

