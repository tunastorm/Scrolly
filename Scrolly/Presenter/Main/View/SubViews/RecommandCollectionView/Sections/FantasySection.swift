//
//  FantasySection.swift
//  Scrolly
//
//  Created by 유철원 on 8/25/24.
//

import Foundation

enum FantasySection: String, MainSection {
    case banner
    case popular
    case newWaitingFree
    case recently
    
    var value: String {
        return self.rawValue
    }
    
    var header: String? {
        return switch self {
        case .newWaitingFree: "기다무 신작"
        case .recently: "최근 본 작품"
        default: nil
        }
    }
    
}
