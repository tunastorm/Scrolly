//
//  NewLabel.swift
//  Scrolly
//
//  Created by 유철원 on 9/8/24.
//

import UIKit
import SnapKit
import Then

final class NewLabel: BaseView {
    
    private let newLabel = UILabel().then {
        $0.text = "NEW"
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .center
        $0.textColor = Resource.Asset.CIColor.white
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.backgroundColor = Resource.Asset.CIColor.blue
    }
    
    override func configHierarchy() {
        addSubview(newLabel)
    }
    
    override func configLayout() {
        newLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        
    }
    
}

