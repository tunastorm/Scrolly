//
//  MainView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MainViewController: BaseViewController<MainView>, UICollectionViewDelegate {
    
    private let disposeBag = DisposeBag()
        
    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        guard let mainViewModel = viewModel as? MainViewModel else {
            return
        }
        let input = MainViewModel.Input()
        let output = mainViewModel.transform(input: input)
        
        output.filterList
            .drive(with: self) { owner, value in
                owner.rootView?.configHashTagView(value)
            }
            .disposed(by: disposeBag)
        
        output.bannerList
            .drive(with: self) { owner, result in
                switch result {
                case .success(let model): print("")
                    guard let postsModel = model as? GetPostsModel else {
                        return
                    }
                    var copy = postsModel.data
                    copy.append(PostsModel())
                    owner.rootView?.configBannerView(copy)
                case .failure(let error):
                    owner.rootView?.makeToast(error.message, duration: 3.0, position: .bottom)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
}
