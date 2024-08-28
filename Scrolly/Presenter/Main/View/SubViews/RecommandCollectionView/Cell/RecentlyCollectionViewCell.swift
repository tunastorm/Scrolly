//
//  RecentlyCollectionViewCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/24/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class RecentlyCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let waitingFreeImageView = WaitingFreeImageView()
    private let waitingFreeLabel = WaitingFreeLabel()
    private let titleLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system10
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private let categoryLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system10
        $0.textColor = Resource.Asset.CIColor.gray
        $0.textAlignment = .left
    }
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(waitingFreeImageView)
        contentView.addSubview(waitingFreeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
    }
    
    override func configLayout() {
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.bottom.equalTo(categoryLabel.snp.top).offset(-4)
            make.horizontalEdges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-6)
        }
        waitingFreeImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(6)
        }
        waitingFreeLabel.snp.makeConstraints { make in
            make.height.equalTo(waitingFreeImageView)
            make.width.equalTo(30)
            make.top.equalToSuperview().inset(6)
            make.leading.equalTo(waitingFreeImageView.snp.trailing)
        }
        
    }
    
    override func configView() {
//        layer.masksToBounds = true
//        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        layer.cornerRadius = 10
        waitingFreeLabel.setFont(font: Resource.Asset.Font.boldSystem10)
    }
    
    override func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        
    }
    
    func configCell(_ identifier: PostsModel) {
        KingfisherManager.shared.setHeaders()
        guard let file = identifier.files.first, let url = URL(string: APIConstants.URI + file) else {
            return
        }
        imageView.kf.setImage(with: url)
        titleLabel.text = identifier.hashTags.first?.replacing("_", with: " ")
        categoryLabel.text = identifier.hashTags[1]
        let isHidden = identifier.content1 == "true"
        waitingFreeToggle(isHidden)
    }
    
    private func waitingFreeToggle(_ isHidden: Bool) {
        waitingFreeImageView.isHidden = isHidden
        waitingFreeLabel.isHidden = isHidden
    }
}
