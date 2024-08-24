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
                                bannerList: PublishSubject<APIManager.ModelResult<GetPostsModel>>(),
                                recomandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                recentlyList: PublishSubject<APIManager.ModelResult<GetPostsModel>>())
    
    struct Input {
        
    }
    
    struct Output {
        let filterList: PublishSubject<[HashTagSection.HashTag]>
        let bannerList: PublishSubject<APIManager.ModelResult<GetPostsModel>>
        let recomandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let recentlyList: PublishSubject<APIManager.ModelResult<GetPostsModel>>
    }

    func transform(input: Input) -> Output? {
        let filterList = BehaviorSubject(value: filterList)
//            .debug("filterList")
//        
        let bannerList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
//            .debug("bannerList")
        
        let popularList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
//            .debug("popularList")
        
        let newWaitingFreeList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
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
            }
            .disposed(by: disposeBag)
        
        BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelEpisode))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
            .bind(with: self) { owner, result in
                owner.output.recentlyList.onNext(result)
            }
            .disposed(by: disposeBag)
            // 중복제거 로직 구현 필요
//            .map{ result in
//                switch result {
//                case .success(let model):
//                    var viewed: [String : (String,String?)] = [:]
//                    let rawViewed = model.data.map { ($0.title, $0.hashTags[2], $0.files.first) }
//                    rawViewed.forEach { values in
//                        
//                    }
//                case .failure(let error):
//                    return
//                }
//            }
        
        
        print(#function, "output 2: ", output)
        return output
    }
    
}
