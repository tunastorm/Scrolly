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
    
}
