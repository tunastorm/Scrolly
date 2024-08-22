//
//  MainViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import Foundation
import RxSwift
import RxCocoa


final class MainViewModel: BaseViewModel, ViewModelProvider {
    
    private let filterList = HashTagSection.HashTag.allCases
    private let limit = "10"
    
    struct Input {
        
    }
    
    struct Output {
        let filterList: Driver<[HashTagSection.HashTag]>
        let bannerList: Driver<APIManager.ModelResult>
    }

    func transform(input: Input) -> Output {
         
        let filterList = Observable.just(filterList)
            .asDriver(onErrorJustReturn: [])
            .debug("filterList")
    
        let bannerList = BehaviorSubject(value: "")
            .map { _ in GetPostsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelEpisode) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0), tokenHandler: nil) }
            .asDriver(onErrorJustReturn: .failure(.unExpectedError))
            .debug("bannerList")
        
        return Output(filterList: filterList, bannerList: bannerList)
    }
    
}
