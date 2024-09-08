//
//  NovelDetailSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import Foundation
import RxDataSources

enum NovelDetailSection: CaseIterable {
    case info
//    case description
//    case hashTag
    case episode
    
    var header: String {
        return switch self {
        case .info: ""
//        case .description: "줄거리"
//        case .hashTag: "키워드"
        case .episode: "전체 " // 테스트 용도
        }
    }

}
 
