//
//  PhoneViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: BaseViewController<PhoneView>{
   
    private let disposeBag = DisposeBag()
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.viewWhite, backButton: true, shadowImage: false, showProfileButton: false)
    }
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? PhoneViewModel else {
            return
        }
        let input = PhoneViewModel.Input(nextTap: rootView.nextButton.rx.tap, phoneNumber: rootView.phoneTextField
            .rx.text)
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        output.phoneNumber
            .drive(rootView.phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.description
            .drive(rootView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(with: self) { owner, isValid in
                let color: UIColor = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
                owner.rootView?.nextButton.backgroundColor = color
                owner.rootView?.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
            
        output.nextTap.bind(with: self) { owner, _ in
                guard let viewModel = viewModel as? PhoneViewModel else {
                    return
                }
                let vc = BirthdayViewController(view: BirthDayView(), viewModel: BirthDayViewModel(builder: viewModel.builder))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

    }

}
