//
//  NovelInfoCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/29/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class EpsisodeHeaderView: BaseCollectionResuableView {
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
    }
    
    private let backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let backButton = CustomButton().then {
        $0.configImage(image: Resource.Asset.SystemImage.chevronLeft)
    }
    private let profileButton = CustomButton().then {
        $0.configImage(image: Resource.Asset.SystemImage.lineThreeHorizontal)
    }
    
    private let coverImageView = UIImageView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let waitingFreeImageView = WaitingFreeImageView()
    
    private let waitingFreeLabel = WaitingFreeLabel()
    
    private let infoBackgroundView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.white
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textAlignment = .center
    }
    
    private let creatorLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textAlignment = .center
    }
    
    private let infoView = InfoView()
    
    
    override func configHierarchy() {
        [backgroundImageView,infoBackgroundView, backgroundBlurView, coverImageView, waitingFreeImageView, waitingFreeLabel, titleLabel, creatorLabel, infoView].forEach {
            addSubview($0)
        }
    }
    
    override func configLayout() {
        coverImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(220)
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        waitingFreeImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.top.equalTo(coverImageView.snp.top).inset(10)
            make.leading.equalTo(coverImageView.snp.leading).inset(10)
        }
        waitingFreeLabel.snp.makeConstraints { make in
            make.height.equalTo(waitingFreeImageView)
            make.width.equalTo(waitingFreeImageView).multipliedBy(2.0)
            make.top.equalTo(coverImageView.snp.top).inset(10)
            make.leading.equalTo(waitingFreeImageView.snp.trailing)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        creatorLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        infoView.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(creatorLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(infoView.snp.bottom)
        }
        backgroundBlurView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(infoView.snp.bottom)
        }
        infoBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(infoView.snp.bottom)
            make.bottom.equalTo(infoView.snp.bottom)
        }
    }
    
    override func configView() {
        
    }
    
    func configData(model: PostsModel) {
        if let file = model.files.first, let url = URL(string: APIConstants.URI + file) {
            KingfisherManager.shared.setHeaders()
            backgroundImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.backgroundImageView.image = data.image
                case .failure(let error):
                    self?.makeToast(error.errorDescription,duration: 3.0, position: .bottom)
                    return
                }
            }
            coverImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.coverImageView.image = data.image
                case .failure(let error):
                    self?.makeToast(error.errorDescription,duration: 3.0, position: .bottom)
                    return
                }
            }
        }
        
        guard model.productId == APIConstants.ProductId.novelInfo else {
           return
        }
        titleLabel.text = model.title
        creatorLabel.text = model.creatorHashTag
        infoView.configData(model)
    }
    
    func configDataAfterNetworking(model: PostsModel) {
        titleLabel.text = model.title
        creatorLabel.text = model.creatorHashTag
        infoView.configData(model)
    }
    
}
