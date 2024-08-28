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
            print("소설 정보 요청")
            callNovelInfoFromEpisode(postId: postId)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let output = Output(fetchedModel: PublishSubject<PostsModel>(),
                                description: PublishSubject<PostsModel>(),
                                hashtag: PublishSubject<PostsModel>())

    struct Input {
        
    }
    
    struct Output {
        var fetchedModel: PublishSubject<PostsModel>
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
    
    private func callNovelInfoFromEpisode(postId: String) {
        var result: APIManager.ModelResult<PostsModel>
        BehaviorSubject(value: postId)
            .flatMap { _ in APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId)) }
            .bind(with: self) { owner, result in
                var data: PostsModel?
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
