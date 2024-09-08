//
//  EpisodeViewViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EpisodeViewerViewModel: BaseViewModel, ViewModelProvider {
  
    typealias DataResult = APIManager.DataResult
    
    private let disposeBag = DisposeBag()
    
    private var novel: PostsModel?
    
    var model: PostsModel? {
        get { novel }
        set { novel = newValue }
    }
    
    init(novel: PostsModel? = nil) {
        super.init()
        self.novel = novel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let output = Output(title: PublishRelay<String>(),
                                model: PublishRelay<DataResult>())
    
    struct Input {
        
    }
    
    struct Output {
        let title: PublishRelay<String>
        let model: PublishRelay<DataResult>
    }
    
    func transform(input: Input) -> Output? {
        
        let title = Observable.just(model?.title)
        
        let file = BehaviorSubject(value: model)
            .map{ $0?.files[1] ?? "" }
            .flatMap{ APIManager.shared.callRequestData(.getPostsImage($0)) }
           
        BehaviorSubject.combineLatest(title, file)
            .bind(with: self) { owner, results in
                guard let title = results.0 else {
                    print(#function, "타이틀 없음")
                    return
                }
                owner.output.title.accept(title)
                owner.output.model.accept(results.1)
//                owner.output.model.onCompleted()
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
}
