//
//  HashTagCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit


final class HashTagCollectionView: BaseCollectionViewController {
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let screenWidth = UIScreen.main.bounds.width
        let keywordItemSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth/4), heightDimension:  .fractionalHeight(1))
        let keywordItem = NSCollectionLayoutItem(layoutSize: keywordItemSize)
        let containerSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth), heightDimension: .absolute(30))
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerSize, subitems: [keywordItem])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 4
        var configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration:  configuration)
        return layout
    }
    
}
