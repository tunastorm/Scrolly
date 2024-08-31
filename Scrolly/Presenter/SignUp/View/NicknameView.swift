//
//  NicknameView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class NicknameView: BaseView {
    
    private let disposeBag = DisposeBag()
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "가입하기")
    
    override func configHierarchy() {
        addSubview(nicknameTextField)
        addSubview(nextButton)
    }
    
    override func configLayout() {
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configView() {
        super.configView()
        nextButton.isEnabled = false
    }
    
}
