//
//  PasswordView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PasswordView: BaseView {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let descriptionLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    let nextButton = PointButton(title: "다음")
    
    override func configHierarchy() {
        addSubview(passwordTextField)
        addSubview(descriptionLabel)
        addSubview(nextButton)
    }
    
    override func configLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        super.configView()
        nextButton.isEnabled = false
    }
    
}
