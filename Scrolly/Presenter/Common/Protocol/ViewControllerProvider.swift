//
//  ViewControllerProvider.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit

protocol UIViewControllerProvider: UIViewController {
        
    func bindData()
    func configInteraction()
    func configNavigationbar(backgroundColor: UIColor, backButton: Bool, shadowImage: Bool, foregroundColor: UIColor, barbuttonColor: UIColor, titlePosition: TitlePosition)
    
}
