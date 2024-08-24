//
//  BannerCollectionViewCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/22/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class BannerCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .top
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let coverView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.black
        $0.alpha = Resource.UIConstants.Alpha.half
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.white
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textAlignment = .left
        $0.numberOfLines = .zero
    }

    private let descriptionLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.white
        $0.font = Resource.Asset.Font.system13
        $0.numberOfLines = 0
    }
    
    private let detailView = UIView()
    
    private let waitingFreeImageView = WaitingFreeImageView()

    private let waitingFreeLabel = WaitingFreeLabel()
    
    private let tagLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.white
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.system10
    }
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailView)
        contentView.addSubview(descriptionLabel)
        detailView.addSubview(waitingFreeImageView)
        detailView.addSubview(waitingFreeLabel)
        detailView.addSubview(tagLabel)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        detailView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(detailView.snp.top).offset(-20)
        }
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-20)
        }
        waitingFreeImageView.snp.makeConstraints { make in
            make.size.equalTo(detailView.snp.height)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        waitingFreeLabel.snp.makeConstraints { make in
            make.height.equalTo(detailView)
            make.width.equalTo(32)
            make.leading.equalTo(waitingFreeImageView.snp.trailing)
            make.verticalEdges.equalToSuperview()
        }
        tagLabel.snp.makeConstraints { make in
            make.height.equalTo(detailView)
            make.width.equalTo(100)
            make.leading.equalTo(waitingFreeLabel.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    override func configView() {
        backgroundColor = Resource.Asset.CIColor.lightGray
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        
    }
    
    func configCell(_ identifier: PostsModel) {
        KingfisherManager.shared.setHeaders()
        guard let file = identifier.files.first, let url = URL(string: APIConstants.URI + "/\(file)") else {
            return
        }
        print(#function, identifier.title, "url: ", url)
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageView.image = data.image.resize(length: self?.contentView.frame.width ?? 350)
            case .failure(let error):
                print("error:", error)
                return
            }
        }
        titleLabel.text = identifier.title
        descriptionLabel.text = identifier.content5
        let hashTags = identifier.hashTags
        let tagString = hashTags[2...3].joined(separator: "﹒")
        tagLabel.text = tagString
        
    }
}
