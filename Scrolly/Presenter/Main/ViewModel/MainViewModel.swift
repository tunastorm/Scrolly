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
        
    private let disposeBag = DisposeBag()
    private let filterList = HashTagSection.HashTag.allCases

    private var output = Output(filterList: PublishSubject<[HashTagSection.HashTag]>(),
                                bannerList: PublishSubject<APIManager.ModelResult>(),
                                recomandDatas: PublishSubject<[APIManager.ModelResult]>())

//                                popularList: PublishSubject<APIManager.ModelResult>(),
//                                newWaitingFreeList: PublishSubject<APIManager.ModelResult>())
    
    struct Input {
        
    }
    
    struct Output {
        let filterList: PublishSubject<[HashTagSection.HashTag]>
        let bannerList: PublishSubject<APIManager.ModelResult>
        let recomandDatas: PublishSubject<[APIManager.ModelResult]>
//        let bannerList: PublishSubject<APIManager.ModelResult>
//        let popularList: PublishSubject<APIManager.ModelResult>
//        let newWaitingFreeList : PublishSubject<APIManager.ModelResult>
    }

    func transform(input: Input) -> Output? {
        let filterList = BehaviorSubject(value: filterList)
//            .debug("filterList")
//        
        let bannerList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelEpisode))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0), tokenHandler: nil) }
//            .debug("bannerList")
        
        let popularList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelEpisode))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0), tokenHandler: nil) }
//            .debug("popularList")
        
        let newWaitingFreeList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelEpisode))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0), tokenHandler: nil) }
//            .debug("popularList")
        
        BehaviorSubject.zip(filterList, bannerList)
            .bind(with: self) { owner, results in
                owner.output.filterList.onNext(results.0)
                owner.output.bannerList.onNext(results.1)
            }
            .disposed(by: disposeBag)
        
        BehaviorSubject.zip(popularList,newWaitingFreeList)
            .bind(with: self) { owner, results in
                owner.output.recomandDatas.onNext([results.0, results.1])
//                owner.output.bannerList.onNext(results.1)
//                owner.output.popularList.onNext(results.2)
//                owner.output.newWaitingFreeList.onNext(results.3)
            }
            .disposed(by: disposeBag)
        
        print(#function, "output 2: ", output)
        return output
    }
    
}
