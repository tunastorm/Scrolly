//
//  SplashViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

enum RefreshTokenNotification {
    static let expired = "refreshTokenExpired"
}


final class SplashViewModel: BaseViewModel, ViewModelProvider {
    
    typealias ModelResult = APIManager.ModelResult
    
    var model: PostsModel?
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(refreshtoken: PublishSubject<ModelResult<RefreshTokenModel>>())
    
    struct Input {
        
    }
    
    struct Output {
        let refreshtoken: PublishSubject<ModelResult<RefreshTokenModel>>
    }
    
    func transform(input: Input) -> Output? {
    
        if UserDefaultsManager.token != "" {
            BehaviorSubject(value: ())
                .bind(with: self) { owner, _ in
                    APIManager.shared.callRequestRefreshToken { result in
                        owner.output.refreshtoken.onNext(result)
                        owner.output.refreshtoken.onCompleted()
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return output
    }
    
}
