//
//  WaitingFreeLabel.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit

final class WaitingFreeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = Resource.UIConstants.Text.waitingFree
        font = Resource.Asset.Font.boldSystem10
        textAlignment = .center
        backgroundColor = Resource.Asset.CIColor.white
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        layer.masksToBounds = true
        layer.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
