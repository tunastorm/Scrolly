//
//  PointButton.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit

class PointButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(Resource.Asset.CIColor.viewWhite, for: .normal)
        backgroundColor = Resource.Asset.CIColor.textBlack
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backgroundToggle(isValid: Bool) {
        backgroundColor = isValid ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.textBlack
    }
    
}

