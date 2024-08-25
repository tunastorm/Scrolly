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
    
    var delegate: HashTagCellDelegate?

    private var indexPath: IndexPath?
    
    private let hashTag = UILabel().then {
        $0.textAlignment = .center
        $0.font = Resource.Asset.Font.system14
    }
    
    override func configHierarchy() {
        contentView.addSubview(hashTag)
    }
    
    override func configLayout() {
        hashTag.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.horizontalEdges.equalToSuperview().inset(10)
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
        print(#function, "\(indexPath)셀 클릭됨", "isSelected:", isSelected)
        if let indexPath {
            isSelected.toggle()
            print(#function, "isSelected:", isSelected)
            delegate?.changeRecentCell(indexPath)
        }
    }
    
    func cellTappedToggle() {
        print(#function, "isSelected: ", isSelected)
        layer.borderWidth = isSelected ? 0 : 1
        backgroundColor = isSelected ? Resource.Asset.CIColor.blue : Resource.Asset.CIColor.white
        hashTag.textColor = isSelected ? Resource.Asset.CIColor.white : Resource.Asset.CIColor.darkGray
    }
    
    func configCell(_ indexPath: IndexPath, _ identifier: HashTagSection.HashTag) {
        self.indexPath = indexPath
        hashTag.text = identifier.krValue
    }
}
