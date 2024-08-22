//
//  HashTagCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit

final class HashTagCollectionView: BaseCollectionViewController {
    
//    static func createLayout() -> UICollectionViewCompositionalLayout {
//        let screenWidth = UIScreen.main.bounds.width
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth/4), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth), heightDimension: .absolute(40))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        var configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.scrollDirection = .horizontal
//        group.contentInsets = .init(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//        section.interGroupSpacing = 4
//        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
//        return layout
//    }
    
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

//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth/4), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth), heightDimension: .absolute(40))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        var configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.scrollDirection = .horizontal
//        group.contentInsets = .init(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//        section.interGroupSpacing = 4
        let layout = UICollectionViewCompositionalLayout(section: section, configuration:  configuration)
        return layout
    }
//    
//    private static func layout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { section, env in
//            switch HashTagSection.allCases[section] {
//            case .keyword:
//                let keywordItemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension:  .fractionalHeight(1))
//                let keywordItem = NSCollectionLayoutItem(layoutSize: keywordItemSize)
//                let containerSize = NSCollectionLayoutSize(widthDimension: .estimated(340), heightDimension: .absolute(30))
//                let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerSize, subitems: [keywordItem])
//                let section = NSCollectionLayoutSection(group: containerGroup)
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//                section.orthogonalScrollingBehavior = .continuous
//                section.interGroupSpacing = 4
//                return section
//            }
//        }
//
//    }
}
