//
//  BaseCollectionViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit

class BaseCollectionViewController: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerHeaderView()
        showScrollInset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerHeaderView() {
        
    }
    
    func showScrollInset(horizontal: Bool = false, vertical: Bool = false) {
        showsHorizontalScrollIndicator = horizontal
        showsVerticalScrollIndicator = vertical
    }
    
}
