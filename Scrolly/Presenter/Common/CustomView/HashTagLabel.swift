//
//  HashTagLabel.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit

final class HashTagLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Resource.Asset.CIColor.gray
        textColor = Resource.Asset.CIColor.darkGray
        font = Resource.Asset.Font.system13
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configText(text: String) {
        self.text = text
    }
    
}

