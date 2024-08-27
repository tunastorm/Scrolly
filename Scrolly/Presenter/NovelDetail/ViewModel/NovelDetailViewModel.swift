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
//    private let apiProvider: APIManagerProvider
    
    var model: PostsModel? {
        get { detailInfo }
        set { detailInfo = newValue }
    }
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(description: PublishSubject<PostsModel>(), 
                                hashtag: PublishSubject<PostsModel>())

   
    struct Input {
        
    }
    
    struct Output {
        let description: PublishSubject<PostsModel>
        let hashtag: PublishSubject<PostsModel>
    }
    
    func transform(input: Input) -> Output? {
        guard let model else {
            return nil
        }
        let novelInfo = BehaviorSubject(value: model)
            
        let episoeds = BehaviorSubject(value: "")
            .map { _ in
                GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelEpisode)
            }
        
        return output
    }
    
}
