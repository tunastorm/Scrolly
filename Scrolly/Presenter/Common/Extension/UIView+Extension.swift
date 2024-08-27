//
//  UIView+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit

extension UIView {
    
    func setHidden(_ isHidden: Bool, animated: Bool) {
        if animated {
            let startAlpha: CGFloat = isHidden ? 1 : 0
            let animatingAlpha: CGFloat = isHidden ? 0 : 1
            
            alpha = startAlpha
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
                if !isHidden { self?.isHidden = isHidden }
                self?.alpha = animatingAlpha
                }, completion: { [weak self] _ in
                    if isHidden { self?.isHidden = isHidden }
            })
            return
        }
        self.isHidden = isHidden
    }
    
}
