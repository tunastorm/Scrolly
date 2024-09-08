//
//  CommentTableView.swift
//  Scrolly
//
//  Created by 유철원 on 9/8/24.
//

import UIKit

final class CommentTableView: BaseCollectionViewController {
    
    private static var screenSize: CGRect?
    
    override func registerHeaderView() {
        self.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.identifier)
    }
    
    static func setScreenSize() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        screenSize = window.screen.bounds
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout  {
        setScreenSize()
//        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let layout = UICollectionViewCompositionalLayout { (sectionIndex,_) -> NSCollectionLayoutSection? in
            return self.createSection(for: CommentSection.allCases[sectionIndex])
        }
        return layout
    }
    
    private static func createSection(for section: CommentSection) -> NSCollectionLayoutSection {
        switch section {
        case .comments:
            return createTableViewSection()
        }
    }
    
    private static func createTableViewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1000))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.pinToVisibleBounds = true /* sticky headerView 구현 프로퍼티*/
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}
