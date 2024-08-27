//
//  NovelDetailViewContreoller.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol NovelDetailViewDelegate {
    
    func popToMainViewController()
    
    func pushToProfileViewController()
    
}
    
final class NovelDetailViewController: BaseViewController<NovelDetailView> {
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<collectionViewHeaderView>
    
    private var detailDataSource: UICollectionViewDiffableDataSource<NovelDetailSection, PostsModel>?
    
    private let descriptionCellRegistration = UICollectionView.CellRegistration<DescriptionCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    private let hashTagCellRegistration = UICollectionView.CellRegistration<HashTagListCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    private let episodeCellRegistration = UICollectionView.CellRegistration<EpisodeCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem?.isHidden = true
        navigationItem.backBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func configInteraction() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.configNavigationbar(backgroundColor: .white, shadowImage: false, foregroundColor: Resource.Asset.CIColor.blue, titlePosition: .left)
    }

    override func bindData() {
//        let input = NovelDetailViewModel.Input()
//        guard let output = viewModel?.transform(input: input) else {
//            return
//        }
    }
    
    private func collectionViewHeaderRegestration(_ sections: [NovelDetailSection], _ noDataSection: NovelDetailSection?) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            if let noDataSection, sections[indexPath.section] == noDataSection {
                return
            }
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }
    
    private func configDataSource(_ sections: [NovelDetailSection]) {
        guard let collectionView = rootView?.collectionView else {
            return
        }
        
        detailDataSource = UICollectionViewDiffableDataSource<NovelDetailSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
             guard let descriptionCellRegistration = self?.descriptionCellRegistration, 
                   let hashTagCellRegistration = self?.hashTagCellRegistration,
                   let episodeCellRegistration = self?.episodeCellRegistration else {
                 return UICollectionViewCell()
             }
             switch sections[indexPath.section] {
             case .description:
                 return collectionView.dequeueConfiguredReusableCell(using: descriptionCellRegistration , for: indexPath, item: itemIdentifier)
             case .hashTag:
                 return collectionView.dequeueConfiguredReusableCell(using: hashTagCellRegistration, for: indexPath, item: itemIdentifier)
             case .episode:
                 return collectionView.dequeueConfiguredReusableCell(using: episodeCellRegistration, for: indexPath, item: itemIdentifier)
             }
         })
        
        
     }
    
    private func updateSnapShot(_ models: [PostsModel], _ section: NovelDetailSection) {
        var snapShot = NSDiffableDataSourceSnapshot<NovelDetailSection, PostsModel>()
        snapShot.appendSections(NovelDetailSection.allCases)
        snapShot.appendItems(models, toSection: section)
        detailDataSource?.apply(snapShot)
    }

}

extension NovelDetailViewController: NovelDetailViewDelegate {
    
    func popToMainViewController() {
        popBeforeView(animated: true)
    }
    
    func pushToProfileViewController() {
        print("프로필 뷰 화면전환 클릭")
    }
    
    
}
