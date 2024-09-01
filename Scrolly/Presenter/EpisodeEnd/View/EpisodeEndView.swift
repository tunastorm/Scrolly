//
//  EpisodeEndView.swift
//  Scrolly
//
//  Created by 유철원 on 9/1/24.
//

import UIKit
import SnapKit
import Then

final class EpisodeEndView: BaseView {
    
    private let bannerView = UIImageView().then {
        $0.contentMode = .bottom
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
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
        $0.image = Resource.Asset.SystemImage.star
        $0.tintColor = Resource.Asset.CIColor.black
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
    
    private let bestCommentLabel = UILabel().then {
        $0.text = "BEST"
        $0.font = Resource.Asset.Font.boldSystem14
        $0.textAlignment = .center
        $0.textColor = Resource.Asset.CIColor.white
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.backgroundColor = Resource.Asset.CIColor.red
    }
    
    private let commentCreatorLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = Resource.Asset.Font.boldSystem13
    }
    
    private let commentLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textAlignment = .left
        $0.numberOfLines = 0
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
        addSubview(bannerView)
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(creatorLabel)
        addSubview(starView)
        addSubview(averageRateLabel)
        addSubview(averageRateButton)
        addSubview(commentImageView)
        addSubview(commentCountLabel)
        addSubview(commentButton)
        addSubview(commentView)
        commentView.addSubview(bestCommentLabel)
        commentView.addSubview(commentCreatorLabel)
        commentView.addSubview(commentLabel)
        addSubview(nextEpisodeView)
        nextEpisodeView.addSubview(nextEpisodeImageView)
        nextEpisodeView.addSubview(viewNextLabel)
        nextEpisodeView.addSubview(nextEpisodeLabel)
        nextEpisodeView.addSubview(nextButton)
    }
    
    override func configLayout() {
        bannerView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(bannerView.snp.bottom).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
        creatorLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(likeButton.snp.leading).offset(10)
        }
        starView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalTo(creatorLabel.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        averageRateLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(40)
            make.leading.equalTo(starView.snp.trailing).offset(4)
            make.centerY.equalTo(starView)
        }
        averageRateButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(likeButton.snp.bottom).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.centerY.equalTo(averageRateLabel)
        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(starView)
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.width.equalTo(40)
            make.leading.equalTo(commentImageView.snp.trailing).offset(4)
            make.centerY.equalTo(commentImageView)
        }
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(averageRateButton)
            make.centerY.equalTo(commentCountLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        commentView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.top.equalTo(commentImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        bestCommentLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(46)
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(10)
        }
        commentCreatorLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(6)
            make.leading.equalTo(bestCommentLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(10)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(bestCommentLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(6)
        }
        nextEpisodeView.snp.makeConstraints { make in
            make.height.equalTo(commentView)
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
    
    override func configView() {
        super.configView()
        bannerView.image = Resource.Asset.NamedImage.splashImage
        titleLabel.text = "멸망한 세계의 4급 인간"
        creatorLabel.text = "외투"
        averageRateLabel.text = "9.8"
        commentCountLabel.text = "62"
        commentCreatorLabel.text = "서울막글리"
        commentLabel.text = "ㅋㅋㅋ 말로는 형제들이라면서 속마음은 외계에서온 외노자취급하넼ㅋㅋㅋ"
        nextEpisodeImageView.image = UIImage(named: "dummyImage_1")
        nextEpisodeLabel.text = "멸망한 세계의 4급 인간 283화"
    }
    
}
