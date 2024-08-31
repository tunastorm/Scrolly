//
//  PhoneView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneView: BaseView {

    let descriptionLabel = CustomLabel()
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func configHierarchy() {
        addSubview(phoneTextField)
        addSubview(descriptionLabel)
        addSubview(nextButton)
    }
    
    override func configLayout() {
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-50)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        super.configView()
        nextButton.isEnabled = false
    }
    
}
