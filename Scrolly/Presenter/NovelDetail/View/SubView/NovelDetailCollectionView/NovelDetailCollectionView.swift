//
//  HashTagCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/27/24.
//

import UIKit

final class NovelDetailCollectionView: BaseCollectionViewController {
    
    private static var screenSize: CGRect?
    
    override func registerHeaderView() {
        self.register(collectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderView.identifier)
    }
    
    static func setScreenSize() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        screenSize = window.screen.bounds
    }

    static func createLayout() -> UICollectionViewCompositionalLayout  {
        setScreenSize()
        let layout = UICollectionViewCompositionalLayout { (sectionIndex,_) -> NSCollectionLayoutSection? in
            return self.createSection(for: NovelDetailSection.allCases[sectionIndex])
        }
        return layout
    }

    private static func createSection(for section: NovelDetailSection) -> NSCollectionLayoutSection {
        switch section {
//        case .description,.hashTag:
//            return createSingleColumnSection()
        case .episode:
            return createTableViewSection()
        }
    }
    
    private static func createSingleColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private static func createTableViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    
}
