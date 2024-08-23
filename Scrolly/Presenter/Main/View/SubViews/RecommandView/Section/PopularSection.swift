//
//  RecommandSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import Foundation


enum PopularSection: Int, CaseIterable {
    
    case popular = 0
    
    var header: String {
        return "인기 작품"
    }
}
