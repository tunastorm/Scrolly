//
//  DescriptionCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit
import SnapKit
import Then

final class DescriptionCell: BaseCollectionViewCell {
    
    let textView = UITextView()
    
    override func configHierarchy() {
        contentView.addSubview(textView)
    }
    
    override func configLayout() {
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func configView() {
        contentView.backgroundColor = Resource.Asset.CIColor.white
    }
    
    func configCell(_ identifier: PostsModel) {
        textView.text = identifier.content
    }
    
}
