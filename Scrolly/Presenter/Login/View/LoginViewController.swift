//
//  LoginViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController<LoginView> {
    
    private let disposeBag = DisposeBag()
    
    override func configInteraction() {
        
    }
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
    }
    
    override func bindData() {
        let input = LoginViewModel.Input(loginTap: PublishSubject<LoginQuery>())
        
        let loginInfo = rootView?.signInButton.rx.tap
            .map { [weak self] _ in
                guard let info = self?.rootView?.getLoginInfo() else {
                    return LoginQuery(email: "", password: "")
                }
                return LoginQuery(email: info.0, password: info.1)
            }.bind(to: input.loginTap)
        
       rootView?.signUpButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let vc = SignUpViewController(view: SignUpView(), viewModel: SignUpViewModel())
                owner.pushAfterView(view: vc, backButton: true, animated: true)
            })
            .disposed(by: disposeBag)
        
        guard let rootView,
              let viewModel = viewModel as? LoginViewModel,
              let output = viewModel.transform(input: input) else {
            return
        }

        let validationToggle = PublishRelay<Bool>()
            .bind(to: rootView.input.validation)
            .disposed(by: disposeBag)
            
        output.result
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    owner.validationUIToggle(isValid: true)
                    owner.changeRootToMain()
                case .failure(let error):
                    owner.showToastToView(error)
                    owner.validationUIToggle(isValid: false)
                }
            }
            .disposed(by: disposeBag)
        
        
    
    }
    
    private func validationUIToggle(isValid: Bool = false) {
        
    }
    
    
    @objc private func changeRootToMain() {
        guard let sceneDelgate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        let vc = MainViewController(view: MainView(), viewModel: MainViewModel())
        sceneDelgate.changeRootVCWithNavi(vc, animated: false)
    }
    
}
