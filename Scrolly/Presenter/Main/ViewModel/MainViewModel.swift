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
                                recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>())
    
    struct Input {
        
    }
    
    struct Output {
        let filterList: PublishSubject<[HashTagSection.HashTag]>
        let recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
    }
    
    func transform(input: Input) -> Output? {
        let filterList = BehaviorSubject(value: filterList)
          
        let bannerList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
        
        let popularList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
        
        let newWaitingFreeList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "6", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }

        let recentlyList = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelEpisode))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
    
        BehaviorSubject.zip(filterList, bannerList, popularList, newWaitingFreeList, recentlyList)
            .bind(with: self) { owner, results in
                var resultList = [results.1, results.2, results.3, results.4]
                owner.output.recommandDatas.onNext(resultList)
                owner.output.maleDatas.onNext(resultList)
                owner.output.femaleDatas.onNext(resultList)
                owner.output.fantasyDatas.onNext(resultList)
                owner.output.romanceDatas.onNext(resultList)
                owner.output.dateDatas.onNext(resultList)
                owner.output.filterList.onNext(results.0)
            }
            .disposed(by: disposeBag)
        
        
        print(#function, "output 2: ", output)
        return output
    }
    
}
