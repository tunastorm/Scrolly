//
//  NovelDetailViewContreoller.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol NovelDetailViewDelegate {
    
    func popToMainViewController()
    
    func pushToProfileViewController()
    
}
    
final class NovelDetailViewController: BaseViewController<NovelDetailView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem?.isHidden = true
        navigationItem.backBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func configInteraction() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.configNavigationbar(backgroundColor: .white, shadowImage: false, foregroundColor: Resource.Asset.CIColor.blue, titlePosition: .left)
    }

    override func bindData() {
        
    }

}

extension NovelDetailViewController: NovelDetailViewDelegate {
    
    func popToMainViewController() {
        popBeforeView(animated: true)
    }
    
    func pushToProfileViewController() {
        print("프로필 뷰 화면전환 클릭")
    }
    
    
}
