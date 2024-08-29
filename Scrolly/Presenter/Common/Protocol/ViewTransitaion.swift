//
//  Protocol.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit

protocol ViewTransition {
   
    func pushAfterView<T: UIViewControllerProvider>(view: T, backButton: Bool, animated: Bool)
    
    func presentAfterView<T: UIViewControllerProvider>(view: T, presentationStyle: UIModalPresentationStyle, animated: Bool)
    
    func navigationPresentAfterView<T: UIViewControllerProvider>(view: T, style: UIModalPresentationStyle, animated: Bool)
    
    func popBeforeView(animated: Bool)
   
    func popToBeforeView<T: UIViewControllerProvider>(_ view: T, animated: Bool)
    
    func popToRootView(animated: Bool)
}


extension UIViewController: ViewTransition {

    func pushAfterView<T: UIViewControllerProvider>(view: T, backButton: Bool, animated: Bool) {
        if !backButton {
            view.navigationItem.hidesBackButton = true
        }
        self.navigationController?.pushViewController(view, animated: animated)
    }
    
    func presentAfterView<T: UIViewControllerProvider>(view: T, presentationStyle: UIModalPresentationStyle, animated: Bool) {
        view.modalPresentationStyle = presentationStyle
        self.present(view, animated: animated)
    }
    
    func navigationPresentAfterView<T: UIViewControllerProvider>(view: T, style: UIModalPresentationStyle, animated: Bool) {
        let nav = UINavigationController(rootViewController: view)
        nav.navigationItem.hidesBackButton = false
        nav.modalPresentationStyle = style
        present(nav, animated: animated)
    }
    
    func popBeforeView(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToBeforeView<T: UIViewControllerProvider>(_ view: T, animated: Bool) {
        navigationController?.popToViewController(view, animated: animated)
    }
    
    func popToRootView(animated: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }
}
