//
//  NicknameViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NicknameViewController: BaseViewController<NicknameView> {
    
    private let disposeBag = DisposeBag()
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
    }
    
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? NicknameViewModel else {
            return
        }
        
        let input = NicknameViewModel.Input(nick: rootView.nicknameTextField.rx.text.orEmpty, signUp: PublishSubject<Void>())
        
        guard let output = viewModel.transform(input: input) else {
            return
        }
        output.isNotNull
            .bind(with: self) { owner, isValid in
                let color = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
                owner.rootView?.nextButton.isEnabled = isValid
                owner.rootView?.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        rootView.nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert(style: .alert, title: "가입완료", message: "지금까지 설정한 정보로 가입하시겠습니까?") { _ in
                    input.signUp.onNext(())
                    input.signUp.onCompleted()
                }
            }
            .disposed(by: disposeBag)
        
        output.signUpResult
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    let vc = SplashViewController(view: SplashView(), viewModel: SplashViewModel())
                    owner.pushAfterView(view: vc, backButton: true, animated: true)
                case .failure(let error):
                    owner.rootView?.makeToast("가입에 실패하였습니다. 로그인 화면으로 되돌아갑니다.")
                    owner.popToRootView(animated: true)
                }
            }
            .disposed(by: disposeBag)
       
    }

}
