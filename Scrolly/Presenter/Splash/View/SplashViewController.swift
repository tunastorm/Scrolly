//
//  View.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: BaseViewController<SplashView> {
    
    private let disposeBag = DisposeBag()
    
    private var nextView: UIViewController?
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView?.layoutIfNeeded()
    }
    
    override func bindData() {
        let input = SplashViewModel.Input()
        guard let viewModel = viewModel as? SplashViewModel,
              let output = viewModel.transform(input: input) else {
            return
        }
        
        output.refreshtoken
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    owner.nextView = MainViewController(view: MainView(), viewModel: MainViewModel())
                case .failure(let error):
                    owner.nextView = LoginViewController(view: LoginView(), viewModel: LoginViewModel())
                }
            }
            .disposed(by: disposeBag)
        
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeRootview), userInfo: nil, repeats: false)
        timer.tolerance = 0.2
    }
    
    
    @objc func changeRootview() {
        guard let nextView, let sceneDelgate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        sceneDelgate.changeRootVCWithNavi(nextView, animated: false)
    }

}
