//
//  SignUpViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel, ViewModelProvider {
   
    typealias ModelResult = APIManager.ModelResult
    
    var model: PostsModel?
    
    var builder = UserBuilder()
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(validation: PublishRelay<ModelResult<BaseModel>>())
    
    struct Input {
        let validation: PublishRelay<String>
    }
    
    struct Output {
        let validation: PublishRelay<ModelResult<BaseModel>>
    }
    
    func transform(input: Input) -> Output? {
        input.validation
            .map{ EmailValidationQuery(email: $0) }
            .flatMap { APIManager.shared.callRequestAPI(model: BaseModel.self, router: .emailValidation($0)) }
            .bind(to: output.validation)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
