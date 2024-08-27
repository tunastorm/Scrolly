//
//  InfoView.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit

final class InfoView: BaseView {
    
    private let categoryIconView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.dolcPlaintext
        $0.tintColor = Resource.Asset.CIColor.gray
    }
    
    private let infoLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textColor = Resource.Asset.CIColor.gray
    }
    
    private let viewdIconView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.eye
        $0.tintColor = Resource.Asset.CIColor.gray
    }

    private let viewedLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textColor = Resource.Asset.CIColor.gray
    }
    
    private let averageRateIconView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.star
        $0.tintColor = Resource.Asset.CIColor.gray
    }

    private let averageRateLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textColor = Resource.Asset.CIColor.gray
    }
    
    override func configHierarchy() {
        addSubview(categoryIconView)
        addSubview(infoLabel)
        addSubview(viewdIconView)
        addSubview(viewedLabel)
        addSubview(averageRateIconView)
        addSubview(averageRateLabel)
    }
    
    override func configLayout() {
        categoryIconView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.leading.verticalEdges.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIconView.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
        viewdIconView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.leading.equalTo(infoLabel.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
        viewedLabel.snp.makeConstraints { make in
            make.leading.equalTo(viewdIconView.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
        averageRateIconView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.leading.equalTo(viewedLabel.snp.trailing).offset(4)
            make.verticalEdges.equalToSuperview()
        }
        averageRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(averageRateIconView.snp.trailing).offset(4)
            make.trailing.verticalEdges.equalToSuperview()
        }
    }
    
    override func configData(_ model: some Decodable)  {
        guard let post = model as? PostsModel else {
            return
        }
        infoLabel.text = post.categorys + post.uploadDays
        viewedLabel.text = post.viewed
        let averateRate = post.content4?.split(separator: ",").first
        averageRateLabel.text = String(averateRate ?? "0.0")
    }

}

