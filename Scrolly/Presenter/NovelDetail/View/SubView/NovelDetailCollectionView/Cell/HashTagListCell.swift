//
//  HashTagListCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit
import SnapKit
import Then

final class HashTagListCell: BaseCollectionViewCell {
    
    let label = HashTagLabel()
    
    override func configHierarchy() {
        addSubview(label)
    }
    
    override func configLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func configView() {
        
    }
    
    func configCell(_ identifier: PostsModel) {
        
    }
    
}
