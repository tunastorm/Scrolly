//
//  UIViewController+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/24/24.
//

import UIKit

extension UIViewController {
    
    func screen() -> UIScreen? {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return view.window?.windowScene?.screen
        }
        
        return window.screen
    }
    
    func showAlert(style: UIAlertController.Style, title: String, message: String,
                   completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        let ok = UIAlertAction(title: Resource.UIConstants.Text.alertOK,
                               style: .default,
                               handler: completionHandler)
        let cancle = UIAlertAction(title: Resource.UIConstants.Text.alertCancle,
                                   style: .destructive)
        alert.addAction(cancle)
        alert.addAction(ok)
        present(alert, animated: false)
    }
    
    func popPreviousView() {
        guard let viewStack = navigationController?.viewControllers else {
            return
        }
        let previous = viewStack.count - 2
        viewStack[previous].popBeforeView(animated: false)
    }
    
}
