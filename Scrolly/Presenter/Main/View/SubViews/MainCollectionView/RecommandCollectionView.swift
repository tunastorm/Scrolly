//
//  MainCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit


final class RecommandCollectionView: BaseCollectionViewController {
    
    override func registerHeaderView() {
        self.register(RecommandHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommandHeaderView.identifier)
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout  {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex,_) -> NSCollectionLayoutSection? in
            return self.createSection(for: RecommandSection.allCases[sectionIndex])
        }
        return layout
    }

    private static func createSection(for section: RecommandSection) -> NSCollectionLayoutSection {
        switch section {
        case .popular, .newWaitingFree:
            return createThreeXTwoSection(for: section)
        default:
            return createSingleColumnSection() 
        }
    }
    
    private static func createSingleColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    

    private static func createThreeXTwoSection(for sectionInfo: RecommandSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.23))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(2)
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let topInset: CGFloat = sectionInfo.header == nil ? 0 : 10
        section.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 30, trailing: 0)
        section.interGroupSpacing = 2
        return section
    }
    
}
