//
//  EpisodeEndViewController.swift
//  Scrolly
//
//  Created by 유철원 on 9/1/24.
//

import UIKit

final class EpisodeEndViewController: BaseViewController<EpisodeEndView> {
    
    override func configNavigationbar(backgroundColor: UIColor = .clear, backButton: Bool = true, shadowImage: Bool = false, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.white)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func bindData() {
        guard let viewModel = viewModel as? EpisodeEndViewModel else {
            return
        }
        let input = EpisodeEndViewModel.Input()
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        
    }
    
}
