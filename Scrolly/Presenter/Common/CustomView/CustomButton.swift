//
//  BackButton.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit
import SnapKit
import Then

final class CustomButton: UIView {
    
    private let imageView = UIImageView().then {
        $0.tintColor = Resource.Asset.CIColor.white
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleToFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configHierarchy() {
        addSubview(imageView)
    }
    
    private func configLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func configView() {
        
    }
    
    func configImage(image: UIImage?) {
        guard let image else {
            return
        }
        imageView.image = image
    }

}
