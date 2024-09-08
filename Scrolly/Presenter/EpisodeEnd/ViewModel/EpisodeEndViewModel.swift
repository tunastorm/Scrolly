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
    
    private var output = Output(episodeInfo: BehaviorSubject<PostsModel>(value: PostsModel()))
    
    init(model: PostsModel? = nil) {
        super.init()
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        // cosmosView
        // nextEpisodeButtonClicked
    }
    
    struct Output {
        let episodeInfo: BehaviorSubject<PostsModel>
    }
    
    func transform(input: Input) -> Output? {
        
        if let model {
            print(#function, "model: ", model)
            output.episodeInfo.onNext(model)
        }
        
        return output
    }
    
}
