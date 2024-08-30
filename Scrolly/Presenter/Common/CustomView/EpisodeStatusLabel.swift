//
//  EpisodeInfoView.swift
//  Scrolly
//
//  Created by 유철원 on 8/28/24.
//

import UIKit
import SnapKit
import Then

final class EpisodeStatusLabel: BaseView {
    
    var status: ShowingView = .none
    
    enum ShowingView {
        case none
        case upload
        case waitingFree
        case freelabel
    }
    
    private let uploadLabel = UILabel().then {
        $0.text = "UP"
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textColor = Resource.Asset.CIColor.white
        $0.backgroundColor = Resource.Asset.CIColor.blue
    }
    
    private let waitingFreeImageView = WaitingFreeImageView().then {
        $0.clipAllEdges()
    }
    
    private let freeLabel = UILabel().then {
        $0.text = "무료"
        $0.font = Resource.Asset.Font.system10
        $0.textColor = Resource.Asset.CIColor.gray
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.layer.borderColor = Resource.Asset.CIColor.gray.cgColor
        $0.layer.borderWidth = 1
    }
    
    override func configHierarchy() {
        addSubview(freeLabel)
        addSubview(uploadLabel)
        addSubview(waitingFreeImageView)
    }
    
    override func configLayout() {
        freeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.edges.equalToSuperview()
        }
        waitingFreeImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.edges.equalToSuperview()
        }
        uploadLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        backgroundColor = .clear
    }
   
    func toggleShowingView(view: ShowingView = .none) {
        status = view
        freeLabel.isHidden = !(status == .freelabel)
        waitingFreeImageView.isHidden = !(status == .waitingFree)
        uploadLabel.isHidden = !(status == .upload)
    }
    
}
