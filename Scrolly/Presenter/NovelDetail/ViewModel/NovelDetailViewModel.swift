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
    
    typealias GetPostsModelResult = APIManager.ModelResult<GetPostsModel>
    
    private let disposeBag = DisposeBag()
    
    private var detailInfo: PostsModel?

    internal var model: PostsModel? {
        get { detailInfo }
        set { detailInfo = newValue }
    }
    
    private var cursor: [String] = ["0", "0"]
    
//    private var postId :String?
    
    init(detailInfo: PostsModel? = nil) {
        super.init()
        self.detailInfo = detailInfo
        if detailInfo?.productId == APIConstants.ProductId.novelEpisode, let postId = detailInfo?.content5 {
            callNovelInfoFromEpisode(postId: postId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let output = Output(fetchedModel: PublishSubject<PostsModel>(),
                                description: PublishSubject<PostsModel>(),
                                episodes: PublishSubject<GetPostsModelResult>(),
                                viewedList: PublishSubject<GetPostsModelResult>())

    struct Input {
        let viewedNovel: PublishSubject<PostsModel>
        let viewedList: BehaviorSubject<Void>
        let nextCursor: PublishSubject<[String]>
        let prefetchItems: PublishSubject<[IndexPath]>
    }
    
    struct Output {
        var fetchedModel: PublishSubject<PostsModel>
        let description: PublishSubject<PostsModel>
        let episodes: PublishSubject<GetPostsModelResult>
        let viewedList: PublishSubject<GetPostsModelResult>
    }
    
    func transform(input: Input) -> Output? {
        guard let model else {
            return nil
        }
        
        let novelInfo = Observable.just(model)
        let updateLikedTime = PublishSubject<String>()
        let updateEpisode = PublishSubject<String>()
        
        input.nextCursor
            .bind(with: self) { owner, cursours in
                owner.cursor = cursours
            }
            .disposed(by: disposeBag)
        
        let episoeds = BehaviorSubject(value: model.hashTags.first)
            .map { [weak self] in HashTagsQuery(next: self?.cursor[0], limit: "50", productId: APIConstants.ProductId.novelEpisode, hashTag: $0) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
        
//        let inputViewedNovel = input.viewedNovel
//            .asDriver(onErrorJustReturn: PostsModel())
        
        let viewedList = input.viewedList
            .map{ [weak self] _ in LikedPostsQuery(next: self?.cursor[1], limit: "50") }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getLikedPostsSub($0)) }
        
//            .debug("viewedList")
        
//        let viewedToggle = input.viewedNovel
//            .map{($0.postId, LikeQuery(likeStatus: true))}
//            .flatMap { APIManager.shared.callRequestAPI(model: LikeModel.self, router: .likePostsToggleSub($0.0, $0.1)) }
//        
//        let updateEpisode = input.viewedNovel
//            .map { ($0.postId,PostsQuery(productId: nil, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: DateFormatManager.shared.nowString(), content5: nil, files: nil))
//            }
//            .flatMap { APIManager.shared.callRequestAPI(model: PostsModel.self, router: .updatePosts($0.0, $0.1)) }
        
        
        input.viewedNovel
            .map{ [weak self] model in
//                self?.postId = model.postId
                return (model.postId, LikeQuery(likeStatus: true))
            }
            .flatMap { APIManager.shared.callRequestAPI(model: LikeModel.self, router: .likePostsToggleSub($0.0, $0.1)) }
//            .debug("input - viewedNovel")
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    input.viewedList.onNext(())
//                    guard let id = owner.postId else { return }
//                    updateEpisode.onNext(id)
                case .failure(let error): return
                }
            }
            .disposed(by: disposeBag)
        
//        updateEpisode
//            .map { ($0, PostsQuery(productId: nil, title: nil, price: nil, content: nil, content1: nil, content2: nil, content3: nil, content4: DateFormatManager.shared.nowString(), content5: nil, files: nil))
//            }
//            .flatMap { APIManager.shared.callRequestAPI(model: PostsModel.self, router: .updatePosts($0.0, $0.1)) }
//            .debug("input - updateEpisode")
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let model):
//                    input.viewedList.onNext(())
//                case .failure(let error): return
//                }
//            }
//            .disposed(by: disposeBag)
        
        PublishSubject.combineLatest(novelInfo, episoeds, viewedList)
            .bind(with: self) { owner, results in
                owner.output.fetchedModel.onNext(results.0)
                owner.output.fetchedModel.onCompleted()
                owner.output.episodes.onNext(results.1)
                owner.output.viewedList.onNext(results.2)
            }
            .disposed(by: disposeBag)
        
//        PublishSubject.zip(viewedToggle, updateEpisode, resultSelector: { toggle, update in
//            var resultList: [Bool] = []
//            switch toggle {
//            case .success(let model):
//                resultList.append(true)
//            case .failure(let error): resultList.append(false)
//            }
//            
//            switch update {
//            case .success(let model): resultList.append(true)
//            case .failure(let error): resultList.append(false)
//            }
//            return resultList
//        })
//        .debug("좋아요 토글 및 에피소드 업데이트")
//        .bind(with: self) { owner, results in
//            guard results == [true, true] else {
//                return
//            }
//            input.viewedList.onNext(())
//        }
//        .disposed(by: disposeBag)
        
        return output
    }
    
    private func callNovelInfoFromEpisode(postId: String) {
        BehaviorSubject(value: postId)
            .flatMap { _ in APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId)) }
            .debug("callNovelInfoFromEpisode")
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    self.model = model
                    owner.output.fetchedModel.onNext(model)
                    owner.output.fetchedModel.onCompleted()
                case .failure(let error): 
                    print("error")
                }
            }
            .disposed(by: disposeBag)
    }
    
}
