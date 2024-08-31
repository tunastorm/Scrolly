//
//  LoginView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginView: BaseView {
    
    private let disposeBag = DisposeBag()
    
    private let appTitle = UILabel().then {
        $0.text = Resource.UIConstants.Text.appTitle
        $0.textColor = Resource.Asset.CIColor.blue
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 70)
    }

    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인", bgColor: Resource.Asset.CIColor.blue)
    let signUpButton = PointButton(title: "회원가입")
    
    let input = Input(validation: PublishRelay<Bool>())
    
    struct Input {
        let validation: PublishRelay<Bool>
    }
    
    override func configHierarchy() {
        addSubview(appTitle)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)
    }
    
    override func configLayout() {
        appTitle.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalTo(safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(appTitle.snp.bottom).offset(120)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        super.configView()
    }
    
    override func bind() {
        input.validation
            .bind(with: self) { owner, value in
                owner.emailTextField.borderColorToggle(isValid: value)
                owner.passwordTextField.borderColorToggle(isValid: value)
                owner.signInButton.backgroundToggle(isValid: value)
            }
            .disposed(by: disposeBag)
    }
    
    func getLoginInfo() -> (String, String)? {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return nil
        }
        return (email, password)
    }
}
