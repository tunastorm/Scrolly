//
//  MainCollectionView.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import UIKit


final class MainCollectionView: BaseCollectionViewController {
    
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
    
    static func createLayout<T: MainSection>(_ sections: [T]) -> UICollectionViewCompositionalLayout  {
        setScreenSize()
        let layout = UICollectionViewCompositionalLayout { (sectionIndex,_) -> NSCollectionLayoutSection? in
            return self.createSection(for: sections[sectionIndex])
        }
        return layout
    }

    private static func createSection<T: MainSection>(for section: T) -> NSCollectionLayoutSection {
        switch section {
        case is RecommandSection:
            let section = section as! RecommandSection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            case .recently:
                return createOneRowSection(for: section)
            }
        case is MaleSection:
            let section = section as! MaleSection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            }
        case is FemaleSection:
            let section = section as! FemaleSection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            }
        case is FantasySection:
            let section = section as! FantasySection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            }
        case is RomanceSection:
            let section = section as! RomanceSection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            }
        case is DateSection:
            let section = section as! DateSection
            switch section {
            case .banner:
                let height = (screenSize?.width ?? 350) - 40
                return createSingleColumnSection(height)
            case .popular, .newWaitingFree:
                return createThreeXTwoSection(for: section)
            case .recently:
                return createOneRowSection(for: section)
            }
        default:
            let section = RecommandSection.popular
            return createOneRowSection(for: section)
        }
    }

    private static func createSingleColumnSection(_ height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10.0, bottom: 0, trailing: 10.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private static func createThreeXTwoSection<T: MainSection>(for sectionInfo: T) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let topInset: CGFloat = sectionInfo.header == nil ? 4 : 10
        section.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 10, bottom: 30, trailing: 10)
        section.interGroupSpacing = 4
        return section
    }
    
    private static func createOneRowSection<T: MainSection> (for sectionInfo: T) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let topInset: CGFloat = sectionInfo.header == nil ? 4 : 10
        section.interGroupSpacing = 4
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 10, bottom: 10, trailing: 0)
        
        return section
    }
    
}
