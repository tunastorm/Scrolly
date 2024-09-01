//
//  SplashView.swift
//  Scrolly
//
//  Created by 유철원 on 8/31/24.
//

import UIKit
import SnapKit
import Then

final class SplashView: BaseView {
    
    private let titleLabel = UILabel().then {
        $0.text = Resource.UIConstants.Text.appTitle
        $0.textColor = Resource.Asset.CIColor.white
        $0.font = .boldSystemFont(ofSize: 80)
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = Resource.UIConstants.Text.appSubTitle
        $0.textAlignment = .right
        $0.textColor = Resource.Asset.CIColor.white
        $0.font = Resource.Asset.Font.system20
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .top
    }
    
    private let coverView = UIView().then {
        $0.backgroundColor = Resource.Asset.CIColor.blue
        $0.alpha = 0.85
    }
    
    override func configHierarchy() {
        addSubview(imageView)
        addSubview(coverView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.trailing.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(300)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configView() {
        guard let width = screen()?.bounds.width else {
            return
        }
        imageView.image = Resource.Asset.NamedImage.splashImage.resize(length: width * 2.5)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        animateAppTitle()
    }
    
    private func animateAppTitle() {
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            self?.titleLabel.font = .boldSystemFont(ofSize: 100)
        })
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            self?.titleLabel.font = .boldSystemFont(ofSize: 80)
        })
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            self?.titleLabel.font = .boldSystemFont(ofSize: 60)
        })
    }
}


