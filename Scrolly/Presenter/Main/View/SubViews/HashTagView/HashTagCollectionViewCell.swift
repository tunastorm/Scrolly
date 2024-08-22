//
//  HashTagCollectionViewCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit
import SnapKit
import Then

final class HashTagCollectionViewCell: BaseCollectionViewCell {
    
//    private var isSelected = false
    
    private let hashTag = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
    }
    
    override func configHierarchy() {
        contentView.addSubview(hashTag)
    }
    
    override func configLayout() {
        hashTag.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.firstBaseline.equalTo(contentView.layoutMargins.top).multipliedBy(1)
        }
    }
    
    override func configView() {
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = 14
        layer.borderColor = Resource.Asset.CIColor.gray.cgColor
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(gesture)
        cellTappedToggle()
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        
    }
    
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
//        isSelected.toggle()
        cellTappedToggle()
    }
    
    private func cellTappedToggle() {
        layer.borderWidth = isSelected ? 0 : 1
        backgroundColor = isSelected ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.white
        hashTag.textColor = isSelected ? Resource.Asset.CIColor.white : Resource.Asset.CIColor.darkGray
    }
    
    func configCell(_ identifier: HashTagSection.HashTag) {
        hashTag.text = identifier.krValue
    }
}
