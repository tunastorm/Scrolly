//
//  EpisodeEndView.swift
//  Scrolly
//
//  Created by 유철원 on 9/1/24.
//

import UIKit
import Cosmos
import Kingfisher
import SnapKit
import Then

final class EpisodeEndView: BaseView {
    
    var delegate: EpisodeEndViewDelegate?
    
    private let starRateView = UIView()
    
    private let myRateLabel = UILabel().then {
        $0.text = "내가 남긴 별점"
        $0.textColor = Resource.Asset.CIColor.gray
        $0.textAlignment = .center
        $0.font = Resource.Asset.Font.system15
    }
    
    private let starRateLabel = UILabel().then {
        $0.text = "10"
        $0.textColor = Resource.Asset.CIColor.blue
        $0.textAlignment = .center
        $0.font = Resource.Asset.Font.boldSystem16
    }
    
    private let cosmosView = CosmosView().then {
        $0.rating = 5
        $0.settings.totalStars = 5
        $0.settings.fillMode = .half
        $0.settings.minTouchRating = 0.5
        $0.settings.updateOnTouch = true
        $0.settings.starSize = 30
//        $0.settings.filledImage = Resource.Asset.SystemImage.starFill
//        $0.settings.emptyImage = Resource.Asset.SystemImage.star
        $0.settings.filledColor = Resource.Asset.CIColor.blue
        $0.settings.filledBorderColor = Resource.Asset.CIColor.blue
        $0.settings.emptyColor = Resource.Asset.CIColor.lightGray
        $0.settings.emptyBorderColor = Resource.Asset.CIColor.lightGray
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.boldSystem16
    }
    
    private let creatorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.system10
    }
    
    private let likeButton = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.heart
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Asset.CIColor.black
    }
    
    private let starView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.starFill
        $0.tintColor = Resource.Asset.CIColor.blue
        $0.contentMode = .scaleAspectFit
    }
    
    private let averageRateLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textAlignment = .left
    }
    
    private let averageRateButton = UIButton().then {
        $0.setTitle("별점", for: .normal)
        $0.setImage(Resource.Asset.SystemImage.chevronRight, for: .normal)
        $0.tintColor = Resource.Asset.CIColor.black
    }
    
    private let commentImageView = UIImageView().then {
        $0.image = Resource.Asset.SystemImage.message
        $0.tintColor = Resource.Asset.CIColor.black
        $0.contentMode = .scaleAspectFit
    }
    
    private let commentCountLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textAlignment = .left
    }
    
    private let commentButton = UIButton().then {
        $0.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        $0.setTitle("댓글", for: .normal)
        $0.setImage(Resource.Asset.SystemImage.chevronRight, for: .normal)
        $0.tintColor = Resource.Asset.CIColor.black
        $0.contentHorizontalAlignment = .right
    }
    
    private let commentView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Resource.Asset.CIColor.lightGray.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let newCommentLabel = NewLabel()
    
    private let commentCreatorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.boldSystem13
    }
    
    private let commentLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.numberOfLines = 2
    }
    
    private let nextEpisodeView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.lightGray
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let nextEpisodeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let viewNextLabel = UILabel().then {
        $0.text = "다음화 보기"
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textAlignment = .left
    }
    
    private let nextEpisodeLabel = UILabel().then {
        $0.textColor = Resource.Asset.CIColor.gray
        $0.font = Resource.Asset.Font.system10
        $0.textAlignment = .left
    }
    
    private let nextButton = UIButton().then {
        $0.setImage(Resource.Asset.SystemImage.chevronRight, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 0)
        $0.tintColor = Resource.Asset.CIColor.black
    }
    
    override func configHierarchy() {
        addSubview(starRateView)
        starRateView.addSubview(myRateLabel)
        starRateView.addSubview(starRateLabel)
        addSubview(cosmosView)
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(creatorLabel)
        addSubview(starView)
        addSubview(averageRateLabel)
//        addSubview(averageRateButton)
        addSubview(commentImageView)
        addSubview(commentCountLabel)
        addSubview(commentButton)
        addSubview(commentView)
        commentView.addSubview(newCommentLabel)
        commentView.addSubview(commentCreatorLabel)
        commentView.addSubview(commentLabel)
        addSubview(nextEpisodeView)
        nextEpisodeView.addSubview(nextEpisodeImageView)
        nextEpisodeView.addSubview(viewNextLabel)
        nextEpisodeView.addSubview(nextEpisodeLabel)
        nextEpisodeView.addSubview(nextButton)
    }
    
    override func configLayout() {
        starRateView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(130)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        myRateLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        starRateLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(myRateLabel.snp.trailing)
        }
        cosmosView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(starRateView.snp.bottom).offset(6)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(cosmosView.snp.bottom).offset(40)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        starView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalTo(cosmosView.snp.bottom).offset(50)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
        averageRateLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(24)
            make.centerY.equalTo(starView)
            make.leading.equalTo(starView.snp.trailing)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalTo(cosmosView.snp.bottom).offset(50)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(averageRateLabel.snp.trailing).offset(4)
        }
        creatorLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(starView.snp.leading).offset(6)
        }
//        averageRateButton.snp.makeConstraints { make in
//            make.size.equalTo(20)
//            make.top.equalTo(likeButton.snp.bottom).offset(20)
//            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
//            make.centerY.equalTo(averageRateLabel)
//        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(starView)
            make.top.equalTo(creatorLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(40)
            make.leading.equalTo(commentImageView.snp.trailing).offset(4)
            make.centerY.equalTo(commentImageView)
        }
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(commentCountLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalTo(commentImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        newCommentLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(44)
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(10)
        }
        commentCreatorLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(6)
            make.leading.equalTo(newCommentLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(10)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(newCommentLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(6)
        }
        nextEpisodeView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(commentView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        nextEpisodeImageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
        viewNextLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(80)
            make.centerY.equalTo(nextEpisodeImageView).offset(-10)
            make.leading.equalTo(nextEpisodeImageView.snp.trailing).offset(10)
        }
        nextEpisodeLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.centerY.equalTo(nextEpisodeImageView).offset(10)
            make.leading.equalTo(nextEpisodeImageView.snp.trailing).offset(10)
        }
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        guard let vc = viewController as? EpisodeEndViewController else {
            return
        }
        delegate = vc
    }
    
    override func configView() {
        super.configView()
        titleLabel.text = "멸망한 세계의 4급 인간"
        creatorLabel.text = "외투"
        averageRateLabel.text = "9.8"
        commentCountLabel.text = "62"
        commentCreatorLabel.text = ""
        nextEpisodeImageView.image = UIImage(named: "dummyImage_1")
        nextEpisodeLabel.text = "멸망한 세계의 4급 인간 283화"
        cosmosView.didTouchCosmos = { [weak self] rating in
            self?.starRateLabel.text = String(Int(rating * 2))
        }
        cosmosView.didFinishTouchingCosmos = { [weak self] rating in
            // delegate 로 ViewModel에 input
        }
    }
    
    override func configData(_ model: some Decodable) {
        guard let episode = model as? PostsModel else {
            return
        }
        print(#function, "episode: ", episode)
        titleLabel.text = episode.title
//        creatorLabel.text = episode.creatorHashTag
//        averageRateLabel.text =
        print(#function, "commentCount: ", episode.comments.count)
        commentCountLabel.text = String(episode.comments.count)
        commentToggle(lastComment: episode.comments.first)
        
        if let file = episode.files.first, let url = URL(string: APIConstants.URI + file) {
            KingfisherManager.shared.setHeaders()
            nextEpisodeImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.nextEpisodeImageView.image = data.image
                case .failure(let error):
                    self?.makeToast(error.errorDescription,duration: 3.0, position: .bottom)
                    return
                }
            }
        }
        if let rawNextNumber = episode.content1, let nextNumber = Int(rawNextNumber) {
            nextEpisodeLabel.text = episode.titleHashTag + " \(nextNumber + 2)화"
        }
            
    }
    
    private func commentToggle(lastComment: Comment?) {
        if let lastComment {
            commentCreatorLabel.text = lastComment.creator.nick
            commentLabel.text = lastComment.content
            commentLabel.textAlignment = .left
            commentLabel.textColor = Resource.Asset.CIColor.black
            commentCreatorLabel.snp.updateConstraints { make in
                make.height.equalTo(16)
            }
            newCommentLabel.snp.updateConstraints { make in
                make.height.equalTo(16)
            }
            commentLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
            }
        } else {
            newCommentLabel.isHidden = true
            commentLabel.text = "등록된 댓글이 없습니다"
            commentLabel.textAlignment = .center
            commentLabel.textColor = Resource.Asset.CIColor.gray
            commentCreatorLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            newCommentLabel.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            commentLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        }
    }
    
    @objc func commentButtonTapped() {
        delegate?.presentCommentViewController()
    }
    
}
