//
//  LoginViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel, ViewModelProvider {
    
    typealias ModelResult = APIManager.ModelResult
    
    var model: PostsModel?
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(result: PublishSubject<ModelResult<LoginModel>>())
    
    struct Input {
        let loginTap: PublishSubject<LoginQuery>
    }
    
    struct Output {
        let result: PublishSubject<ModelResult<LoginModel>>
    }
    
    func transform(input: Input) -> Output? {
        
        input.loginTap
            .flatMap { APIManager.shared.callRequestLogin(.login($0)) }
            .bind(to: output.result)
        
        return output
    }
    
}
