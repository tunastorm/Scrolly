//
//  NovelDetailViewContreoller.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol NovelDetailViewDelegate {
    
    func getModel() -> PostsModel?
    
    func popToMainViewController()
    
    func pushToProfileViewController()
    
}
    
final class NovelDetailViewController: BaseViewController<NovelDetailView> {

    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<collectionViewHeaderView>
    
    private let disposeBag = DisposeBag()
    
//    private var detailDataSource: UICollectionViewDiffableDataSource<NovelDetailSection, PostsModel>?
    
    private let descriptionCellRegistration = UICollectionView.CellRegistration<DescriptionCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier) 
    }
    
    private let hashTagCellRegistration = UICollectionView.CellRegistration<HashTagListCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let episodeCellRegistration = UICollectionView.CellRegistration<EpisodeCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private func collectionViewHeaderRegestration(_ sections: [NovelDetailSectionModel]) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }

    lazy var detailDataSource = RxCollectionViewSectionedAnimatedDataSource<NovelDetailSectionModel> (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let cellRegistration = self?.episodeCellRegistration else {
                return UICollectionViewCell()
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, title, indexPath in
            guard let headerRegistration = self?.collectionViewHeaderRegestration(dataSource.sectionModels) else {
                return UIView() as! UICollectionReusableView
            }
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })
    
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

    override func bindData() {
        guard let detailViewModel = viewModel as? NovelDetailViewModel, let rootView else {
            return
        }
        let input = NovelDetailViewModel.Input()
        guard let output = detailViewModel.transform(input: input) else {
            return
        }
        
        output.fetchedModel
            .bind(with: self) { owner, model in
                owner.rootView?.configDataAfterNetworking(model: model)
            }
            .disposed(by: disposeBag)
       
//        output.description
//            .bind(with: self) { owner, model in
//                owner.updateSnapShot([model], .description)
//            }
//            .disposed(by: disposeBag)
//        
//        output.hashtag
//            .bind(with: self) { owner, model in
//                owner.updateSnapShot([model], .hashTag)
//            }
//            .disposed(by: disposeBag)
        

//        output.episodes
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let model):
//                    let sorted = owner.sortingEpiosdes(list: model.data)
//                    owner.updateSnapShot(sorted, .episode)
//                case .failure(let error):
//                    owner.showToastToView(error)
//                }
//            }
//            .disposed(by: disposeBag)
        
        output.episodes
            .map { [weak self] result in
                switch result {
                case .success(let model):
                    guard let sorted = self?.sortingEpiosdes(list: model.data) else {
                        return [NovelDetailSectionModel(header: "", items: [])]
                    }
                    return [NovelDetailSectionModel(header: NovelDetailSection.episode.header, items: sorted)]
                case .failure(let error):
                    self?.showToastToView(error)
                    return [NovelDetailSectionModel(header: "", items: [])]
                }
            }
            .bind(to: rootView.collectionView.rx.items(dataSource: detailDataSource))
            .disposed(by: disposeBag)
        
        rootView.collectionView.rx.modelSelected(NovelDetailSectionModel.Item.self)
            .bind(with: self) { owner, item in
                let vc = EpisodeViewerViewController(view: EpisodeViewerView(), viewModel: EpisodeViewerViewModel(novel: item))
                owner.pushAfterView(view: vc, backButton: true, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func sortingEpiosdes(list: [PostsModel], accending: Bool = false) -> [PostsModel] {
        return list.sorted {
            if let left = Int($0.content1 ?? ""), let right = Int($1.content1  ?? "") {
                return accending == true ? left < right : left > right
            }
            return false
        }
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
    
//    private func configDataSource(_ sections: [NovelDetailSection]) {
//        guard let collectionView = rootView?.collectionView else {
//            return
//        }
//        
//        detailDataSource = UICollectionViewDiffableDataSource<NovelDetailSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
//             guard let descriptionCellRegistration = self?.descriptionCellRegistration, 
//                   let hashTagCellRegistration = self?.hashTagCellRegistration,
//                   let episodeCellRegistration = self?.episodeCellRegistration else {
//                 return UICollectionViewCell()
//             }
//             switch sections[indexPath.section] {
////             case .description:
////                 return collectionView.dequeueConfiguredReusableCell(using: descriptionCellRegistration , for: indexPath, item: itemIdentifier)
////             case .hashTag:
////                 return collectionView.dequeueConfiguredReusableCell(using: hashTagCellRegistration, for: indexPath, item: itemIdentifier)
//             case .episode:
//                 return collectionView.dequeueConfiguredReusableCell(using: episodeCellRegistration, for: indexPath, item: itemIdentifier)
//             }
//         })
//        
//     }
//    
//    private func updateSnapShot(_ models: [PostsModel], _ section: NovelDetailSection) {
//        var snapShot = NSDiffableDataSourceSnapshot<NovelDetailSection, PostsModel>()
//        snapShot.appendSections(NovelDetailSection.allCases)
//        snapShot.appendItems(models, toSection: section)
//        detailDataSource?.apply(snapShot)
//    }

}

extension NovelDetailViewController: NovelDetailViewDelegate {
    
    func getModel() -> PostsModel? {
        return viewModel?.model
    }
    
    func popToMainViewController() {
        popBeforeView(animated: true)
    }
    
    func pushToProfileViewController() {
        print("프로필 뷰 화면전환 클릭")
    }
    
    
}
