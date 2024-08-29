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
    
    var model: PostsModel? {
        get { detailInfo }
        set { detailInfo = newValue }
    }
    
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
                                hashtag: PublishSubject<PostsModel>(),
                                episodes: PublishSubject<GetPostsModelResult>())

    struct Input {
        
    }
    
    struct Output {
        var fetchedModel: PublishSubject<PostsModel>
        let description: PublishSubject<PostsModel>
        let hashtag: PublishSubject<PostsModel>
        let episodes: PublishSubject<GetPostsModelResult>
    }
    
    func transform(input: Input) -> Output? {
        guard let model else {
            return nil
        }
        
        let novelInfo = Observable.just(model)
       
        let episoeds = BehaviorSubject(value: model.hashTags.first)
            .map { HashTagsQuery(next: nil, limit: "50", productId: APIConstants.ProductId.novelEpisode, hashTag: $0) }
            .flatMap { APIManager.shared.callRequestAPI(model: GetPostsModel.self, router: .searchHashTags($0)) }
        
        BehaviorSubject.zip(novelInfo, episoeds)
            .bind(with: self) { owner, results in
                let episodes = results.1
                owner.output.fetchedModel.onNext(results.0)
//                owner.output.description.onNext(results.0)
//                owner.output.description.onCompleted()
//                owner.output.hashtag.onNext(results.0)
//                owner.output.hashtag.onCompleted()
                owner.output.episodes.onNext(results.1)
                owner.output.episodes.onCompleted()
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
                case .failure(let error): print("error")
                }
            }
            .disposed(by: disposeBag)
    }
        
}
