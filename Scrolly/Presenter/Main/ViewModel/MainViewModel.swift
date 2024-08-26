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
    
    typealias NetworkResults = Observable<PrimitiveSequence<SingleTrait, Result<GetPostsModel, APIError>>.Element>
    
    private var recommandResults: [Int : NetworkResults] = [:]
    private var maleResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var femaleResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var fantasyResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var romanceResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var dateResults: [Int : PublishSubject<HashTagsQuery>] = [:]

    private var output = Output(filterList: BehaviorSubject<[HashTagSection.HashTag]>(value: HashTagSection.HashTag.allCases),
                                recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>())
    
    struct Input {
        let hashTagCellTap: ControlEvent<IndexPath>
//        let hashTagCellTap: PublishSubject<HashTagSection.HashTag>
    }
    
    struct Output {
        let filterList: BehaviorSubject<[HashTagSection.HashTag]>
        let recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
    }
    
    func transform(input: Input) -> Output? {
      
        callRecommandDatas()
        PublishSubject.zip(recommandResults.sorted { $0.key < $1.key }.map{ $0.value })
            .bind(with: self) { owner, results in
                owner.output.recommandDatas.onNext(results)
                owner.output.dateDatas.onNext(results)
            }
            .disposed(by: disposeBag)
        
        allViewSubjects()
        input.hashTagCellTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .debug("해시태그 셀 클릭")
            .bind(with: self) { owner, i in
                switch HashTagSection.HashTag.allCases[i.item] {
                case .male: owner.callMaleDatas()
                case .female: owner.callFemaleDatas()
                case .fantasy: owner.callFantasyDatas()
                case .romance: owner.callRomanceDatas()
                case .day: owner.callRecommandDatas() // 요일 별 뷰 구현 전까지 사용
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        var novelInfoResults: [String : [NetworkResults]] = [:]
        
        (HashTagSection.HashTag.allCases).forEach { section in
            var results: [Int: PublishSubject<HashTagsQuery>]
            switch section {
            case .male: results = maleResults
            case .female: results = femaleResults
            case .fantasy: results = fantasyResults
            case .romance: results = romanceResults
            case .day: results = dateResults
            default: return
            }
            novelInfoResults[section.rawValue] = results.values.map { results in
                results.flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
                .debug("\(section.rawValue) 네크워킹")
            }
        }
     
        PublishSubject.zip(novelInfoResults[HashTagSection.HashTag.male.rawValue] ?? [])
            .bind(with: self) { owner, results in
                owner.output.maleDatas.onNext(results)
            }
            .disposed(by: disposeBag)
        
        PublishSubject.zip(novelInfoResults[HashTagSection.HashTag.female.rawValue] ?? [])
            .bind(with: self) { owner, results in
                owner.output.femaleDatas.onNext(results)
            }
            .disposed(by: disposeBag)

        PublishSubject.zip(novelInfoResults[HashTagSection.HashTag.fantasy.rawValue] ?? [])
            .bind(with: self) { owner, results in
                owner.output.fantasyDatas.onNext(results)
            }.disposed(by: disposeBag)
        
        PublishSubject.zip(novelInfoResults[HashTagSection.HashTag.romance.rawValue] ?? [])
            .bind(with: self) { owner, results in
                owner.output.romanceDatas.onNext(results)
            }.disposed(by: disposeBag)
        
        return output
    }

    private func allViewSubjects() {
        //MARK: - 남성인기
        (0...MaleSection.allCases.count-1).forEach { maleResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 여성인기
        (0...FemaleSection.allCases.count-1).forEach { femaleResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 판타지
        (0...FantasySection.allCases.count-1).forEach { fantasyResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 로맨스
        (0...RomanceSection.allCases.count-1).forEach { romanceResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 요일
        (0...DateSection.allCases.count-1).forEach { dateResults[$0] = PublishSubject<HashTagsQuery>() }
    }
    
    private func callRecommandDatas() {
        guard recommandResults.values.isEmpty else {
            return
        }
        recommandResults[0] = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "\(Int.random(in: 10...20))", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
        
        recommandResults[1] = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelInfo))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
      
        recommandResults[2] = BehaviorSubject(value:  HashTagsQuery(next: nil, limit: "6", productId:  APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.waitingFree))
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
      
        recommandResults[3] = BehaviorSubject(value: GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelEpisode) )
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
    }
    
    private func callMaleDatas() {
        maleResults.keys.forEach { key in
            let query = MaleSection.allCases[key].query
            if let result = maleResults[key] {
                result.onNext(query)
                result.onCompleted()
                print(#function, "남성인기 쿼리 방출")
            }
        }
    }
    
    private func callFemaleDatas() {
        femaleResults.keys.forEach { key in
            let query = FemaleSection.allCases[key].query
            if let result = femaleResults[key] {
                result.onNext(query)
                result.onCompleted()
            }
        }
    }
    
    private func callFantasyDatas() {
        fantasyResults.keys.forEach { key in
            let query = FantasySection.allCases[key].query
            if let result = fantasyResults[key] {
                result.onNext(query)
                result.onCompleted()
            }
        }
    }
    
    private func callRomanceDatas() {
        romanceResults.keys.forEach { key in
            let query = RomanceSection.allCases[key].query
            if let result = romanceResults[key] {
                result.onNext(query)
                result.onCompleted()
            }
        }
    }
    
    private func callDateDatas() {
//        romanceResults[0] = BehaviorSubject(value: HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.romance) )
//            .flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
//        
//        romanceResults[1] = BehaviorSubject(value: HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.romance) )
//            .flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
//        
//        romanceResults[2] = BehaviorSubject(value: HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.romance) )
//            .flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
//        
//        romanceResults[3] = BehaviorSubject(value: HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.romance) )
//            .flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
    }
    
}
