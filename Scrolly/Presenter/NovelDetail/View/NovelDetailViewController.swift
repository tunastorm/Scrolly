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

    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>
    typealias CellRegistration<T: BaseCollectionViewCell> = UICollectionView.CellRegistration<T, PostsModel>
    
    private let disposeBag = DisposeBag()
    
    private let descriptionCellRegistration = CellRegistration<DescriptionCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let infoCellRegistration = CellRegistration<InfoCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let episodeCellRegistration = CellRegistration<EpisodeCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private var headerRegistration: HeaderRegistration?
   
    private func collectionViewHeaderRegestration(_ sections: [NovelDetailSectionModel]) -> HeaderRegistration {
        HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
          
        }
    }

    lazy var detailDataSource = RxCollectionViewSectionedAnimatedDataSource<NovelDetailSectionModel> (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            let section = NovelDetailSection.allCases[indexPath.section]
            
            if section == .info, let cellRegistration = self?.infoCellRegistration {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
            
            if section == .episode, let cellRegistration = self?.episodeCellRegistration {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
            return UICollectionViewCell()
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let headerRegistration = self?.headerRegistration else {
                return UICollectionReusableView()
            }
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem?.isHidden = true
        navigationItem.backBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func bindData() {
        guard let detailViewModel = viewModel as? NovelDetailViewModel, let rootView else {
            return
        }
        let input = NovelDetailViewModel.Input()
        guard let output = detailViewModel.transform(input: input) else {
            return
        }
    
        PublishSubject<[NovelDetailSectionModel]>
            .zip(output.fetchedModel, output.episodes) { [weak self] novel, episodes in
                let headerView = CollectionViewHeaderView()
                var sectionList = [
                    NovelDetailSectionModel(header: headerView, items: []),
                    NovelDetailSectionModel(header: headerView, items: [])
                ]
                switch episodes {
                case .success(let model):
                    guard let data = self?.sortingEpiosdes(list: model.data) else {
                        return sectionList
                    }
                    self?.headerRegistration = self?.collectionViewHeaderRegestration(sectionList)
                    sectionList[0].items = [novel]
                    sectionList[1].items = data
                    return sectionList
                case .failure(let error):
                    self?.showToastToView(error)
                    return sectionList
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
