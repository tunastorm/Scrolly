//
//  BirthDayViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BirthdayViewController: BaseViewController<BirthDayView> {
   
    private let disposeBag = DisposeBag()
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
    }
    
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? BirthDayViewModel else {
            return
        }
        let input = BirthDayViewModel.Input(picekdDate: rootView.birthDayPicker.rx.date, nextTap: rootView.nextButton.rx.tap)
        guard let output = viewModel.transform(input:input) else {
            return
        }
         
        output.pickedDate
            .bind(to: rootView.pickedDateLabel.rx.text)
            .disposed(by: disposeBag)
       
       
        output.isValid
            .drive(with: self) { owner, isValid in
                owner.rootView?.descriptionLabel.text = isValid ? "가입가능한 나이입니다." : "17세 이상만 가입가능"
                owner.rootView?.descriptionLabel.textColor = isValid ? .blue : .red
                owner.rootView?.nextButton.backgroundColor = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
                owner.rootView?.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
       
        output.nextTap
            .bind(with: self) { owner, _ in
                guard let viewModel = owner.viewModel as? BirthDayViewModel else {
                    return
                }
                let vc = NicknameViewController(view: NicknameView(), viewModel: NicknameViewModel(builder:   viewModel.builder))
               owner.pushAfterView(view: vc, backButton: true, animated: true)
            }
            .disposed(by: disposeBag)
    
    }
    
}

