//
//  RecommandCollectionViewCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class RecommandCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
//    private let coverView = UIImageView().then {
//        $0.contentMode = .scaleAspectFill
//        $0.alpha = 0.25
//    }
//    
    private let waitingFreeImageView = WaitingFreeImageView()
    
    private let waitingFreeLabel = WaitingFreeLabel()
    
//    private let creatorLabelView = CreatorLabelView()
    
    override func configHierarchy() {
        contentView.addSubview(imageView)
//        contentView.addSubview(coverView)
//        contentView.addSubview(creatorLabelView)
        contentView.addSubview(waitingFreeImageView)
        contentView.addSubview(waitingFreeLabel)
    }
    
    override func configLayout() {
//        creatorLabelView.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
//        coverView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        waitingFreeImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(6)
        }
        waitingFreeLabel.snp.makeConstraints { make in
            make.height.equalTo(waitingFreeImageView)
            make.width.equalTo(32)
            make.top.equalToSuperview().inset(6)
            make.leading.equalTo(waitingFreeImageView.snp.trailing)
        }
    }
    
    override func configView() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    override func configInteractionWithViewController<T: UIViewController >(viewController: T) {
        
    }
    
    func configCell(_ identifier: PostsModel) {
        KingfisherManager.shared.setHeaders()
        guard let file = identifier.files.first, let url = URL(string: APIConstants.URI + "/\(file)") else {
            return
        }
        imageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageView.image = data.image.resize(length: self?.contentView.frame.width ?? 100)
            case .failure(let error):
                print(#function, "error: ", error)
            }
        }
        let isHidden = identifier.content1 == "true"
        waitingFreeToggle(!isHidden)
    }
    
    private func waitingFreeToggle(_ isHidden: Bool) {
        waitingFreeImageView.isHidden = isHidden
        waitingFreeLabel.isHidden = isHidden
    }

    
}
