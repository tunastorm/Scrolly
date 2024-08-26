//
//  NovelDetailViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NovelDetailViewModel: BaseViewModel, ViewModelProvider {
    
    private var detailInfo: PostsModel?
    
    var model: PostsModel? {
        get { detailInfo }
        set { detailInfo = newValue }
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output? {
        return Output()
    }
    
}
