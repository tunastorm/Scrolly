//
//  CommentViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 9/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentViewModel: BaseViewModel, ViewModelProvider {

    var model: PostsModel?
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(title: BehaviorSubject<String>(value: ""),
                                comments: BehaviorSubject<[Comment]>(value: []))
    
    init(model: PostsModel? = nil) {
        super.init()
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let comment: PublishSubject<String>
        let newModel: PublishSubject<Void>
    }
    
    struct Output {
        let title: BehaviorSubject<String>
        let comments: BehaviorSubject<[Comment]>
    }
    
    func transform(input: Input) -> Output? {
    
        if let model {
            output.title.onNext(model.title ?? "없음")
            output.comments.onNext(model.comments)
            
            input.comment
                .map { CommentsQuery(content: $0)}
                .flatMap { APIManager.shared.callRequestAPI(model: CommentsModel.self, router: .uploadComments(model.postId, $0)) }
                .bind(with: self) { owner, result in
                    switch result {
                    case .success(let model): input.newModel.onNext(())
                    case .failure(let error): return
                    }
                }
                .disposed(by: disposeBag)
            
            input.newModel
                .map{ model.postId }
                .flatMap { APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts($0)) }
                .bind(with: self) { owner, result in
                    switch result {
                    case .success(let model): 
                        owner.model = model
                        owner.output.comments.onNext(model.comments)
                    case .failure(let error): return
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return output
    }
    
}

