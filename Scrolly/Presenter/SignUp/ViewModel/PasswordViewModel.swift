//
//  PasswordViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel: BaseViewModel, ViewModelProvider {
    
    var model: PostsModel?
    
    var builder: UserBuilder?
    
    private let disposeBag = DisposeBag()
    
    private let output = Output(description: Observable.just("8자 이상 입력해주세요"), validation: PublishSubject<Bool>())
    
    init(model: PostsModel? = nil, builder: UserBuilder? = nil) {
        super.init()
        self.model = model
        self.builder = builder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Input {
        let password: ControlProperty<String>
    }
    
    struct Output {
        let description: Observable<String>
        let validation: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output? {
        
        input.password
            .map{ [weak self] value in
                let isValid = value.count >= 8
                if isValid {
                    self?.builder = self?.builder?.withPassword(value)
                }
                return isValid
            }
            .bind(to: output.validation)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
