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
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let collectionView = NovelDetailCollectionView(frame: .zero, collectionViewLayout: NovelDetailCollectionView.createLayout())
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    override func configHierarchy() {
        addSubview(topView)
        topView.addSubview(backgroundImageView)
        [infoBackgroundView, backgroundBlurView, coverImageView, waitingFreeImageView, waitingFreeLabel, titleLabel, creatorLabel, infoView].forEach {
            topView.addSubview($0)
        }
//        [infoBackgroundView, backgroundBlurView, coverImageView, waitingFreeImageView, waitingFreeLabel, titleLabel, creatorLabel, infoView, hashTagView, collectionView ].forEach { view in
//            contentView.addSubview(view)
//        }
        addSubview(collectionView)
        addSubview(continueBar)
        addSubview(backButton)
        addSubview(profileButton)
    }
    
    override func configLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
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
        continueBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
//        hashTagView.snp.makeConstraints { make in
//            make.height.equalTo(120)
//            make.top.equalTo(infoView.snp.bottom).offset(10)
//            make.horizontalEdges.equalToSuperview().inset(10)
//        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview()
        }
       
    }
    
    override func configView() {
        super.configView()
        scrollView.isScrollEnabled = true
        let backbuttonTap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(backbuttonTap)
        let profileButtonTap = UITapGestureRecognizer(target: self, action: #selector(profileButtonTapped))
        profileButton.addGestureRecognizer(profileButtonTap)
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        
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
    
//    func setScrollview() {
//        // 스크롤뷰 기본 설정 - 충분한 높이로 임의로 설정
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1200)
//        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 1200)
//
//        // 스크롤뷰 높이 조정 (컬렉션뷰 동적 높이 + 그외 view 고정 높이)
//            func updateScrollViewHeight() {
//                let newHeight = collectionView.collectionViewLayout.collectionViewContentSize.height + 400
//                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: newHeight)
//                contentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: newHeight)
//            }
//
//        // 마지막 cell을 그릴 때 updateScrollViewHeight를 호출해 scrollView 높이 줄이기
//            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RDFilterCollectionViewCell.identifier, for: indexPath) as? RDFilterCollectionViewCell else { return UICollectionViewCell() }
//
//                if indexPath.section == yourLastSection && indexPath.item == yourLastItem {
//                    updateScrollViewHeight()
//                }
//
//                return cell
//            }
//    }
    
}

extension NovelDetailView: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//      guard let constraint = headerHeightConstraint else { return }
//      //    print(scrollView.contentOffset.y)
//      
//      let remainingTopSpacing = abs(scrollView.contentOffset.y)
//      let lowerThanTop = scrollView.contentOffset.y < 0
//      let stopExpandHeaderHeight = scrollView.contentOffset.y > -Metric.headerHeight
//      
//      if stopExpandHeaderHeight, lowerThanTop {
//        // 1) 초기 상태: UIImageView가 지정한 크기만큼 커졌고, 스크롤뷰의 시작점이 최상단보다 아래 존재
//        collectionView.contentInset = .init(top: remainingTopSpacing, left: 0, bottom: 0, right: 0)
//        constraint.constant = remainingTopSpacing
//        headerImageView.alpha = remainingTopSpacing / Metric.headerHeight
//        view.layoutIfNeeded()
//      } else if !lowerThanTop {
//        // 2) 스크롤 뷰의 시작점이 최상단보다 위에 존재
//        collectionView.contentInset = .zero
//        constraint.constant = 0
//        headerImageView.alpha = 0
//      } else {
//        // 3) 스크롤 뷰의 시작점이 최상단보다 밑에 있고, 스크롤뷰 상단 contentInset이 미리 지정한 UIImageView 높이인, Metric.headerHeight보다 큰 경우
//        constraint.constant = remainingTopSpacing
//        headerImageView.alpha = 1
//      }
//    }
}
