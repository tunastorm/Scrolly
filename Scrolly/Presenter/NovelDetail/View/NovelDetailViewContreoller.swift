//
//  NovelDetailViewContreoller.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NovelDetailViewContreoller: BaseViewController<NovelDetailView> {
    
    override func configInteraction() {
        
    }
    
    override func configNavigationbar(backgroundColor: UIColor, shadowImage: Bool, foregroundColor: UIColor = .black, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: .clear, shadowImage: false, foregroundColor: .white)
    }
    
    override func bindData() {
        print("작품 상세 화면입니다")
        print("model: ", viewModel?.model)
    }

}
