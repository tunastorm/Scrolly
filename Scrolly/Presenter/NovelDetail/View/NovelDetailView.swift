//
//  NovelDetailView.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import SnapKit
import Then

final class NovelDetailView: BaseView {
    
    private let backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let waitingFreeImageView = WaitingFreeImageView()
    
    private let waitingFreeLabel = WaitingFreeLabel()
    
    private let titleLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem20
        $0.textAlignment = .center
    }
    
    private let creatorLabel = UILabel().then {
        $0.font = Resource.Asset.Font.system13
        $0.textAlignment = .center
    }
    
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
    
    override func configHierarchy() {
        addSubview(backgroundImageView)
        addSubview(backgroundBlurView)
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(creatorLabel)
        addSubview(categoryIconView)
        addSubview(infoLabel)
        addSubview(viewdIconView)
        addSubview(viewedLabel)
        addSubview(averageRateIconView)
        addSubview(averageRateLabel)
        addSubview(hashTagView)
        addSubview(descriptionTextView)
    }
    
    override func configLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.horizontalEdges.equalToSuperview()
        }
        backgroundBlurView.snp.makeConstraints { make in
        
        }
    }
    
    override func configView() {
      
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        
    }
    
}
