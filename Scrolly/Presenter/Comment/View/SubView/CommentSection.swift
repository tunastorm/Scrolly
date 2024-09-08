//
//  CommentSection.swift
//  Scrolly
//
//  Created by 유철원 on 9/8/24.
//

import Foundation

enum CommentSection: CaseIterable {
    case comments
    
    var header: String {
        return switch self {
        case .comments: "전체"
        }
    }

}
