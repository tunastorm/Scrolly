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
    
    private let output = Output(title: PublishSubject<String>(),
                                model: PublishSubject<DataResult>())
    
    struct Input {
        
    }
    
    struct Output {
        let title: PublishSubject<String>
        let model: PublishSubject<DataResult>
    }
    
    func transform(input: Input) -> Output? {
        
        print(#function, "pdf 경로: ", model?.files[1])
        
        let title = Observable.just(model?.title)
        
        let file = BehaviorSubject(value: model)
            .map{ $0?.files[1] ?? "" }
            .flatMap{ APIManager.shared.callRequestData(.getPostsImage($0)) }
           
        
        BehaviorSubject.zip(title, file)
            .bind(with: self) { owner, results in
                guard let title = results.0 else {
                    return
                }
                owner.output.title.onNext(title)
                owner.output.title.onCompleted()
                owner.output.model.onNext(results.1)
                owner.output.model.onCompleted()
            }
            .disposed(by: disposeBag)
            
            
//            .bind(with: self) { owner, model in
//                guard let model else {
//                    return
//                }
//                owner.output.model.onNext(model)
//                owner.output.model.onCompleted()
//            }
//            .disposed(by: disposeBag)
        
        return output
    }

    
}
