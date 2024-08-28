//
//  NovelDetailSectionModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/29/24.
//

import Foundation
import RxDataSources
import Differentiator


struct NovelDetailSectionModel {
    
    var identity = UUID()
    var header: String
    var items: [Item]
    
}

extension NovelDetailSectionModel: AnimatableSectionModelType {
    
    typealias Item = PostsModel
    typealias Identity = UUID
    
    init(original: NovelDetailSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}




    
