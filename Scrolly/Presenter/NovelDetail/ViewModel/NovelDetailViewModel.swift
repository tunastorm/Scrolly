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
    
    private var cursur: String?
    
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
                                viewesList: PublishSubject<GetPostsModelResult>())

    struct Input {
        let viewedNovel: PublishSubject<PostsModel>
        let viewedList: BehaviorSubject<Void>

    }
    
    struct Output {
        var fetchedModel: PublishSubject<PostsModel>
        let description: PublishSubject<PostsModel>
        let episodes: PublishSubject<GetPostsModelResult>
        let viewesList: PublishSubject<GetPostsModelResult>
    }
    
    func transform(input: Input) -> Output? {
        guard let model else {
            return nil
        }
        
        let novelInfo = Observable.just(model)
       
        let episoeds = BehaviorSubject(value: model.hashTags.first)
            .map { HashTagsQuery(next: nil, limit: "50", productId: APIConstants.ProductId.novelEpisode, hashTag: $0) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
        
        let viewedList = input.viewedList
            .map{ [weak self] _ in LikedPostsQuery(next: self?.cursur, limit: "50") }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .getLikedPostsSub($0)) }
        
        input.viewedNovel
            .map{($0.postId, LikeQuery(likeStatus: true))}
            .flatMap { APIManager.shared.callRequestAPI(model: LikeModel.self, router: .likePostsToggleSub($0.0, $0.1)) }
            .bind(with: self) { owner, model in
                input.viewedList.onNext(())
            }
            .disposed(by: disposeBag)
        
        PublishSubject.combineLatest(novelInfo, episoeds, viewedList)
            .bind(with: self) { owner, results in
                owner.output.fetchedModel.onNext(results.0)
                owner.output.fetchedModel.onCompleted()
                owner.output.episodes.onNext(results.1)
                owner.output.viewesList.onNext(results.2)
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func callNovelInfoFromEpisode(postId: String) {
        BehaviorSubject(value: postId)
            .flatMap { _ in APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId)) }
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
