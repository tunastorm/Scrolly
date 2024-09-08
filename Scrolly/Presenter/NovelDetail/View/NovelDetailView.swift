//
//  NovelDetailView.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class NovelDetailView: BaseView {
    
    var delegate: NovelDetailViewDelegate?
    
    private let topView = UIView()
    
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
    
    private let hashTagView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let descriptionTextView = UITextView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let continueBar = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let collectionView = NovelDetailTableView(frame: .zero, collectionViewLayout: NovelDetailTableView.createLayout())
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    override func configHierarchy() {
        addSubview(collectionView)
        addSubview(continueBar)
        addSubview(backButton)
        addSubview(profileButton)
    }
    
    override func configLayout() {
        backButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(36)
            make.top.equalToSuperview().inset(50)
            make.leading.equalToSuperview().inset(10)
        }
        profileButton.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(30)
            make.top.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        super.configView()
        collectionView.bounces = false
        let backbuttonTap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(backbuttonTap)
        let profileButtonTap = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        profileButton.addGestureRecognizer(profileButtonTap)
    }

    override func configData(_ model: some Decodable) {
        guard let post = model as? PostsModel else {
            return
        }
        if let file = post.files.first, let url = URL(string: APIConstants.URI + file) {
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
        
        guard post.productId == APIConstants.ProductId.novelInfo else {
            print(#function, "소설정보아님", post.productId)
            return

        }
        titleLabel.text = post.title
        creatorLabel.text = post.creatorHashTag
        infoView.configData(model)
    }
    
    func configDataAfterNetworking(model: PostsModel) {
        titleLabel.text = model.title
        creatorLabel.text = model.creatorHashTag
        infoView.configData(model)
    }
    
    @objc private func backButtonTapped() {
        delegate?.popToMainViewController()
    }
    
    @objc private func profileButtonTapped() {
        delegate?.pushToProfileViewController()
    }
}
