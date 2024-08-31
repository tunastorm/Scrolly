//
//  SignUpView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpView: BaseView {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    override func configHierarchy() {
        addSubview(emailTextField)
        addSubview(validationButton)
        addSubview(nextButton)
    }
    
    override func configLayout() {
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        super.configView()
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Resource.Asset.CIColor.textBlack, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Resource.Asset.CIColor.textBlack.cgColor
        validationButton.layer.cornerRadius = 10
        nextButton.isEnabled = false
    }
    
}
