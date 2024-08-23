//
//  HashTagCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit

protocol HashTagCellDelegate {
    var clickedCell: Int? { get set }
    func changeRecentCell(index: Int)
}


final class HashTagCollectionView: BaseCollectionViewController, HashTagCellDelegate {
 
    var recentCell: Int?
    
    var clickedCell: Int? {
        get { return recentCell  }
        set { recentCell = newValue }
    }
    
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
    
    func changeRecentCell(index: Int) {
        
    }
//    
//    private func layout() -> UICollectionViewLayout {
//            let layout = UICollectionViewCompositionalLayout { section, env in
//                switch Section.allCases[section] {
//                case .keyword:
//                    let keywordItemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension:  .fractionalHeight(1))
//                    let keywordItem = NSCollectionLayoutItem(layoutSize: keywordItemSize)
//                    let containerSize = NSCollectionLayoutSize(widthDimension: .estimated(340), heightDimension: .absolute(30))
//                    let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerSize, subitems: [keywordItem])
//                    let section = NSCollectionLayoutSection(group: containerGroup)
//                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//                    section.orthogonalScrollingBehavior = .continuous
//                    section.interGroupSpacing = 4
//                    return section
//                }
//            }
    
}
