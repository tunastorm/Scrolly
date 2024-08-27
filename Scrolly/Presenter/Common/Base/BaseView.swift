//
//  BaseView.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit
import Toast

class BaseView: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        self.backgroundColor = Resource.Asset.CIColor.white
    }
    
    func bind() {
        
    }
    
    func configInteractionWithViewController<T: UIViewController>(viewController: T) {
        
    }
    
    func configData(_ model: some Decodable) {
        
    }
}

