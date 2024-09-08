//
//  CommentSectionModel.swift
//  Scrolly
//
//  Created by 유철원 on 9/8/24.
//

import UIKit
import RxDataSources
import Differentiator

struct CommentSectionModel {
    var identity = UUID()
    var header: UICollectionReusableView
    var items: [Item]
}

extension CommentSectionModel: AnimatableSectionModelType {
    
    typealias Item = Comment
    typealias Identity = UUID
    
    init(original: CommentSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}
