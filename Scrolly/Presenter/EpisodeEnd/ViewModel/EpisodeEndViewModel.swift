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
    
    init(model: PostsModel? = nil, output: Output = Output()) {
        super.init()
        self.model = model
        self.output = output
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output? {
        return output
    }
    
}
