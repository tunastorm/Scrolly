//
//  BaseCollectionViewCell.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit

protocol CollectionViewCellProvider {
    func configHierarchy()
    func configLayout()
    func configView()
    func configInteractionWithViewController<T: UIViewController>(viewController: T)
}


class BaseCollectionViewCell: UICollectionViewCell, CollectionViewCellProvider {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() { }
    
    func configLayout() { }
    
    func configView() { }
    
    func configInteractionWithViewController<T: UIViewController>(viewController: T) { }
    
}
