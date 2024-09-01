//
//  EpisodeEndViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 9/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeEndViewModel: BaseViewModel, ViewModelProvider {
    
    var model: PostsModel?
    
    private var output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output? {
        return output
    }
    
}
