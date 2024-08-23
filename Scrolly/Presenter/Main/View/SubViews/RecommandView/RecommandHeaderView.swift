//
//  RecommandHeaderView.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit
import SnapKit
import Then

final class RecommandHeaderView: BaseCollectionResuableView {
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textColor = Resource.Asset.CIColor.darkGray
    }
    
    override func configHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        backgroundColor = .clear
    }
}
