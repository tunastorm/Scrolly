//
//  WaitingFreeImageView.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit
import SnapKit
import Then

final class WaitingFreeImageView: BaseView {
    
    private let waitingFreeImageView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.stopwatch
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Asset.CIColor.white
    }
    
    override func configHierarchy() {
        addSubview(waitingFreeImageView)
    }
    
    override func configLayout() {
        waitingFreeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        backgroundColor = Resource.Asset.CIColor.blue
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        layer.masksToBounds = true
        layer.cornerRadius = 2
    }
    
}
