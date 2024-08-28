//
//  EpisodeCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class EpisodeCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let infoView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textAlignment = .left
    }
    
    private let uploadDateLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system10
        $0.textColor = Resource.Asset.CIColor.gray
        $0.textAlignment = .left
    }
    
    private let infoLabel = EpisodeInfoLabel()
    
    let showButton = UIButton().then {
        $0.setImage(Resource.Asset.SystemImage.arrowDownToLine, for: .normal)
        $0.tintColor = Resource.Asset.CIColor.gray
        $0.contentMode = .scaleAspectFill
        $0.titleLabel?.font = .systemFont(ofSize: 0)
    }

    override func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(infoView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(uploadDateLabel)
        infoView.addSubview(infoLabel)
        addSubview(showButton)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.verticalEdges.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
        }
        infoView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(100)
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        uploadDateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview()
        }
        infoLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(uploadDateLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        showButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalTo(infoView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    override func configView() {
        
    }
    
    func configCell(_ identifier: PostsModel, last: Bool = false) {
        guard let file = identifier.files.first, let url = URL(string: APIConstants.URI + file) else {
            return
        }
        KingfisherManager.shared.setHeaders()
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageView.image = data.image.resize(length: self?.contentView.frame.width ?? 60)
            case .failure(let error):
                print(#function, "error: ", error)
            }
        }
        titleLabel.text = identifier.title
        uploadDateLabel.text = identifier.createdAt
        
        switch (identifier.content2, identifier.content3) {
        case ("false", "false"): infoLabel.toggleShowingView(view: .freelabel)
        case ("true", "true"): infoLabel.toggleShowingView(view: .waitingFree)
        case ("true", "false"):
            if last {
                infoLabel.toggleShowingView(view: .upload)
                break
            }
            infoLabel.toggleShowingView(view: .none)
            infoLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        default: break
        }

    }
}
