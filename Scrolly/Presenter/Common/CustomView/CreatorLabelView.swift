//
//  CreatorLabelView.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit
import SnapKit
import Then

final class CreatorLabelView: BaseView {
    
    private let creatorLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.white
        $0.font = Resource.Asset.Font.system10
        $0.textAlignment = .center
    }
    
    private let imageView = UIImageView().then {
        $0.image = Resource.Asset.NamedImage.gradationCover
        $0.contentMode = .scaleToFill
        $0.alpha = Resource.UIConstants.Alpha.half
    }
    
    override func configHierarchy() {
        addSubview(imageView)
        addSubview(creatorLabel)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        creatorLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {

    }
    
    func setLabelText(text: String) {
        creatorLabel.text = text
    }
}
