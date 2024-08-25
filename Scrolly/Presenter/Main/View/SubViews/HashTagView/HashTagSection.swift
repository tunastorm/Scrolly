//
//  HashTagSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/22/24.
//

import Foundation


enum HashTagSection: Int, CaseIterable {
    case main = 0
    
    enum HashTag: CaseIterable {
        case recommand
        case male
        case female
        case fantasy
        case romance
        case day
        
        var krValue: String {
            return switch self {
            case .recommand: "추천"
            case .male: "남성인기"
            case .female: "여성인기"
            case .fantasy: "판타지"
            case .romance: "로맨스"
            case .day: "요일"
            }
        }
    }
    
    static func krHashTags() -> [String] {
        return HashTag.allCases.map { $0.krValue }
    }
}
    
