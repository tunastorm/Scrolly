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
    
    typealias PostListResults = Observable<PrimitiveSequence<SingleTrait, Result<GetPostsModel, APIError>>.Element>
    
    var model: PostsModel? {
        get { return nil }
        set { }
    }
    
    private var recommandCall: [PublishSubject<Void>] = []
    private var recommandResults: [Int : PostListResults] = [:]
    private var maleResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var femaleResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var fantasyResults: [Int : PublishSubject<HashTagsQuery>] = [:]
    private var romanceResults: [Int : PublishSubject<HashTagsQuery>] = [:]
//    private var dateResults: [Int : PublishSubject<HashTagsQuery>] = [:]

    private var output = Output(filterList: BehaviorSubject<[HashTagSection.HashTag]>(value: HashTagSection.HashTag.allCases),
                                recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
//                                dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>(),
                                recommandCellTap: PublishSubject<PostsModel>())
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let callRecommandData: PublishSubject<Void>
        let hashTagCellTap: ControlEvent<IndexPath>
        let srollViewPaging: PublishRelay<IndexPath>
    }
    
    struct Output {
        let filterList: BehaviorSubject<[HashTagSection.HashTag]>
        let recommandDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let maleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let femaleDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let fantasyDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let romanceDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
//        let dateDatas: PublishSubject<[APIManager.ModelResult<GetPostsModel>]>
        let recommandCellTap: PublishSubject<PostsModel>
    }
    
    func transform(input: Input) -> Output? {
      
        var novelInfoResults: [String : [PostListResults]] = [:]
        
        setAllSubjects()
        callRecommandDatas()
        
        input.callRecommandData
            .bind(with: self) { owner, _ in
                owner.recommandCall.forEach { $0.onNext(()) }
            }
            .disposed(by: disposeBag)
        
        PublishSubject.combineLatest(recommandResults.sorted { $0.key < $1.key }.map{ $0.value })
            .bind(with: self) { owner, results in
                owner.output.recommandDatas.onNext(results)
            }
            .disposed(by: disposeBag)
        
        input.hashTagCellTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, indexPath in
                owner.callDataRouter(indexPath)
            }
            .disposed(by: disposeBag)
        
        input.srollViewPaging
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, indexPath in
                guard indexPath.item >= 0, indexPath.item < HashTagSection.HashTag.allCases.count else {
                    return
                }
                owner.callDataRouter(indexPath)
            }
            .disposed(by: disposeBag)
        
        (HashTagSection.HashTag.allCases).forEach { section in
            var results: [Int: PublishSubject<HashTagsQuery>]
            switch section {
            case .male: results = maleResults
            case .female: results = femaleResults
            case .fantasy: results = fantasyResults
            case .romance: results = romanceResults
//            case .day: results = dateResults
            default: return
            }
            
            novelInfoResults[section.rawValue] = results.sorted { $0.key < $1.key }.map{ $0.value }.map { results in
                results.flatMap{ APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
//                .debug("\(section.rawValue) 네크워킹")
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

    private func setAllSubjects() {
        //MARK: - HOT 추천
        (0...RecommandSection.allCases.count-1).forEach { _ in recommandCall.append(PublishSubject<Void>()) }
        //MARK: - 남성인기
        (0...MaleSection.allCases.count-1).forEach { maleResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 여성인기
        (0...FemaleSection.allCases.count-1).forEach { femaleResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 판타지
        (0...FantasySection.allCases.count-1).forEach { fantasyResults[$0] = PublishSubject<HashTagsQuery>() }
        //MARK: - 로맨스
        (0...RomanceSection.allCases.count-1).forEach { romanceResults[$0] = PublishSubject<HashTagsQuery>() }
//        //MARK: - 요일
//        (0...DateSection.allCases.count-1).forEach { dateResults[$0] = PublishSubject<HashTagsQuery>() }
    }
    
    private func callDataRouter(_ indexPath: IndexPath) {
        switch HashTagSection.HashTag.allCases[indexPath.item] {
        case .male: callDatas(for: MaleSection.allCases)
        case .female: callDatas(for: FemaleSection.allCases)
        case .fantasy: callDatas(for: FantasySection.allCases)
        case .romance: callDatas(for: RomanceSection.allCases)
//        case .day: callRecommandDatas()
        default: return
        }
    }

    private func callDatas<T:MainSection>(for sections: [T]) {
        var results: [Int : PublishSubject<HashTagsQuery>]
        switch sections {
        case is [MaleSection]: results = maleResults
        case is [FemaleSection]: results = femaleResults
        case is [FantasySection]: results = fantasyResults
        case is [RomanceSection]: results = romanceResults
//        case is [DateSection]: results = dateResults
        default: return
        }
        
        results.keys.forEach { key in
            let query = sections[key].query
            if let result = results[key] {
                result.onNext(query)
                result.onCompleted()
            }
        }
    }
    
    private func callRecommandDatas() {
        recommandResults[RecommandSection.banner.index] = recommandCall[0]
            .map { GetPostsQuery(next: nil, limit: "\(Int.random(in: 10...20))", productId: APIConstants.ProductId.novelInfo) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
        
        recommandResults[RecommandSection.popular.index] = recommandCall[1]
            .map { GetPostsQuery(next: nil, limit: "20", productId: APIConstants.ProductId.novelInfo) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getPosts($0)) }
      
        recommandResults[RecommandSection.recently.index] = recommandCall[2]
            .map { LikedPostsQuery(next: nil, limit: "50") }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getLikedPostsSub($0)) }
//            .debug("likedPostsSub")
        
        recommandResults[RecommandSection.newWaitingFree.index] = recommandCall[3]
            .map { RecommandSection.newWaitingFree.query }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
    }
    
    private func callDateDatas() {
            
    }
    
}
