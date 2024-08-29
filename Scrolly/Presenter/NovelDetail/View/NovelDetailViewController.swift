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

    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<EpsisodeHeaderView>
    
    private let disposeBag = DisposeBag()
    
    private let descriptionCellRegistration = UICollectionView.CellRegistration<DescriptionCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier) 
    }
    
    private let hashTagCellRegistration = UICollectionView.CellRegistration<HashTagListCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let episodeCellRegistration = UICollectionView.CellRegistration<EpisodeCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private var headerRegistration: UICollectionView.SupplementaryRegistration<EpsisodeHeaderView>?
   
    private func collectionViewHeaderRegestration(_ sections: [NovelDetailSectionModel]) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<EpsisodeHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            let model = sections[indexPath.section].header
            supplementaryView.configData(model: model)
        }
    }

    lazy var detailDataSource = RxCollectionViewSectionedAnimatedDataSource<NovelDetailSectionModel> (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let cellRegistration = self?.episodeCellRegistration else {
                return UICollectionViewCell()
            }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
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
                switch episodes {
                case .success(let model):
                    guard let data = self?.sortingEpiosdes(list: model.data) else {
                        return [NovelDetailSectionModel(header: novel, items: [])]
                    }
                    let sectionList = [NovelDetailSectionModel(header: novel, items: data)]
                    self?.headerRegistration = self?.collectionViewHeaderRegestration(sectionList)
                    return sectionList
                case .failure(let error):
                    self?.showToastToView(error)
                    return [NovelDetailSectionModel(header: novel, items: [])]
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
