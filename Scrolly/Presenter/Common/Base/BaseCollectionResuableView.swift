//
//  BaseCollectionResuableView.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit

protocol UICollectionReusableViewProvider {
    func configHierarchy()
    func configLayout()
    func configView()
}

class BaseCollectionResuableView: UICollectionReusableView, UICollectionReusableViewProvider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        
    }
    
}



