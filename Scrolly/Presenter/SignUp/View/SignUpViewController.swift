//
//  SignUpView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController<SignUpView> {
    
    private let disposeBag = DisposeBag()
    
    private let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    private lazy var emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? SignUpViewModel else {
            return
        }
        
        print(#function, "왜 안됨_1")
        let input = SignUpViewModel.Input(validation: PublishRelay<String>())
        guard let output = viewModel.transform(input: input) else {
            return
        }
        print(#function, "왜 안됨_2")
        rootView.emailTextField.rx.text.orEmpty
            .map { [weak self] text in self?.emailPredicate.evaluate(with: text) }
            .bind(with: self) { owner, value in
                guard let value else { return }
                owner.rootView?.validationButton.isHidden = !value
            }
            .disposed(by: disposeBag)
        
        rootView.validationButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let text = owner.rootView?.emailTextField.text else {
                    return
                }
                input.validation.accept(text)
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let model):
                    owner.rootView?.makeToast(model.message)
                    let isValid = model.message == "사용 가능한 이메일입니다." ? true : false
                    let color: UIColor = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
                    owner.rootView?.nextButton.isEnabled = isValid
                    owner.rootView?.nextButton.backgroundColor = color
                    owner.rootView?.validationButton.isHidden = isValid
                case .failure(let error):
                    owner.showToastToView(error)
                }
            })
            .disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let email = rootView.emailTextField.text else {
                    return
                }
                let builder = UserBuilder().withEmail(email)
                let vc = PasswordViewController(view: PasswordView(), viewModel: PasswordViewModel(builder: builder))
                owner.pushAfterView(view: vc, backButton: true, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
