//
//  EpisodeViewViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import Foundation

final class EpisodeViewerViewModel: BaseViewModel, ViewModelProvider {
    
    private var novel: PostsModel?
    
    var model: PostsModel? {
        get { novel }
        set { novel = newValue }
    }

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output? {
        var output: Output?
        
        return output
    }

    
}
