//
//  SignTextField.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit

class SignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        textColor = Resource.Asset.CIColor.textBlack
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Resource.Asset.CIColor.textBlack.cgColor
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func borderColorToggle(isValid: Bool) {
        layer.borderColor = isValid ? 
        Resource.Asset.CIColor.blue.cgColor : Resource.Asset.CIColor.textBlack.cgColor
    }
}

