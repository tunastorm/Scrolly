//
//  PasswordViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PasswordViewController: BaseViewController<PasswordView> {
    
    private let disposeBag = DisposeBag()
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
    }
    
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? PasswordViewModel else {
            return
        }
        
        let input = PasswordViewModel.Input(password: rootView.passwordTextField.rx.text.orEmpty)
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        output.description
            .bind(to: rootView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self, onNext: { owner, isValid in
                let color = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
                owner.rootView?.nextButton.isEnabled = isValid
                owner.rootView?.nextButton.backgroundColor = color
                owner.rootView?.descriptionLabel.isHidden = isValid
            })
            .disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let viewModel = viewModel as? PasswordViewModel,
                      let text = owner.rootView?.passwordTextField.text else {
                    return
                }
                guard let builder = viewModel.builder?.withPassword(text) else {
                    return
                }
                let vc = PhoneViewController(view: PhoneView(), viewModel: PhoneViewModel(builder: builder))
                owner.pushAfterView(view: vc, backButton: true, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
