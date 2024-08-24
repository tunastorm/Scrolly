//
//  MainCollectionViewSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import Foundation

enum RecommandSection: String, CaseIterable {
    case banner
//    case ad
    case popular
    case newWaitingFree
    case recently
    
    var header: String? {
        return switch self {
        case .newWaitingFree: "기다무 신작"
        case .recently: "최근 본 작품"
        default: nil
        }
    }
    
}
