//
//  NicknameViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: BaseViewModel, ViewModelProvider {
    
    typealias ModelResult = APIManager.ModelResult
    
    var model: PostsModel?
    
    var builder: UserBuilder?
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(isNotNull: PublishSubject<Bool>(),
                                signUpResult: PublishSubject<ModelResult<SignUpModel>>())
    
    init(model: PostsModel? = nil, builder: UserBuilder? = nil) {
        super.init()
        self.model = model
        self.builder = builder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let nick: ControlProperty<String>
        let signUp: PublishSubject<Void>
    }

    struct Output {
        let isNotNull: PublishSubject<Bool>
        let signUpResult: PublishSubject<ModelResult<SignUpModel>>
    }
    
    func transform(input: Input) -> Output? {
        
        input.nick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { [weak self] value in
                let isValid = value.count > 0
                if isValid {
                    self?.builder = self?.builder?.withNickname(value)
                }
                return isValid
            }
            .bind(to: output.isNotNull)
            .disposed(by: disposeBag)
        
        input.signUp
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map{ [weak self] _ in
                self?.builder?.build() ?? SignUpQuery(email: "", password: "", nick: "")
            }
            .debug("input - signUp")
            .flatMap { APIManager.shared.callRequestAPI(model: SignUpModel.self, router: .signUp($0))}
            .bind(to: output.signUpResult)
            .disposed(by: disposeBag)
       
        return output
    }
    
}
