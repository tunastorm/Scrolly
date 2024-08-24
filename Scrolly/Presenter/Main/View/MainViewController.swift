//
//  MainView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MainViewController: BaseViewController<MainView> {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - CollectionView DiffableDataSources
    private var filterDataSource: UICollectionViewDiffableDataSource<HashTagSection, HashTagSection.HashTag>?
    private var bannerDataSource: UICollectionViewDiffableDataSource<BannerSection, PostsModel>?
    private var recommandDataSource: UICollectionViewDiffableDataSource<RecommandSection, PostsModel>?
    private var recentlyDataSource: UICollectionViewDiffableDataSource<RecentlySection, PostsModel>?

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool) {
        super.configNavigationbar(navigationColor: navigationColor, shadowImage: shadowImage)
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {
        guard let mainViewModel = viewModel as? MainViewModel else {
            return
        }
        let input = MainViewModel.Input()
        guard let output = mainViewModel.transform(input: input) else {
            return
        }
        output.filterList
            .bind(with: self) { owner, value in
                owner.configFilterDataSource()
                owner.updateFilterSnapShot(value)
            }
            .disposed(by: disposeBag)
        
        output.bannerList
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    owner.configBannerDataSource()
                    owner.updateBannerSnapShot(model.data)
                    owner.rootView?.configBannerLabel(model.data.count)
                case .failure(let error):
                    owner.showToastToView(error)
                }
            }
            .disposed(by: disposeBag)
        
        output.recomandDatas
            .bind(with: self) { owner, results in
                var list: [[PostsModel]] = []
                results.forEach { result in
                    switch result {
                    case .success(let model):
                        list.append(model.data)
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.configRecommandDataSource(sections: RecommandSection.allCases)
                owner.updateRecommandSnapShot(list, for: RecommandSection.allCases)
            }
            .disposed(by: disposeBag)
        
        output.recentlyList
            .bind(with: self) { owner, result in
                switch result {
                case .success(let model):
                    print("최근 본 작품 리스트")
                    var viewed: [PostsModel] = []
                    model.data.forEach { posts in
                        if viewed.last?.hashTags.first == posts.hashTags.first {
                            return
                        }
                        viewed.append(posts)
                    }
                    owner.configRecentlyDataSource(section: .recently)
                    owner.updateRecentlySnapShot(viewed, for: .recently)
                case .failure(let error):
                    owner.showToastToView(error)
                }
            }.disposed(by: disposeBag)
    }
    
    private func showToastToView(_ error: APIError) {
        rootView?.makeToast(error.message, duration: 3.0, position: .bottom)
    }
    
    //MARK: - 해시태그 필터 콜렉션뷰
    private func filterCellRegistration() -> UICollectionView.CellRegistration<HashTagCollectionViewCell, HashTagSection.HashTag> {
        UICollectionView.CellRegistration<HashTagCollectionViewCell, HashTagSection.HashTag> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
    }
    
    private func configFilterDataSource() {
        guard let collectionView = rootView?.hashTagView else {
            return
        }
         let cellRegistration = filterCellRegistration()
         filterDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
             let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
             return cell
         })
     }
    
    private func updateFilterSnapShot(_ hashTags: [HashTagSection.HashTag]) {
        var snapShot = NSDiffableDataSourceSnapshot<HashTagSection, HashTagSection.HashTag>()
        snapShot.appendSections(HashTagSection.allCases)
        snapShot.appendItems(hashTags, toSection: .main)
        filterDataSource?.apply(snapShot)
    }
    
    //MARK: - 배너 콜렉션뷰
    private func bannerCellRegistration() -> UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> {
        UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
    }
    
    private func configBannerDataSource() {
        guard let collectionView = rootView?.bannerView else {
            return
        }
        let cellRegistration = bannerCellRegistration()
        bannerDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateBannerSnapShot(_ model: [PostsModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<BannerSection, PostsModel>()
        snapShot.appendSections(BannerSection.allCases)
        snapShot.appendItems(model, toSection: .main)
        bannerDataSource?.apply(snapShot)
    }
    
    //MARK: - 추천 콜렉션뷰
    private func recommandCellRegistration() -> UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> {
        UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configRecommandCell(itemIdentifier)
        }
    }
    
    private func newWaitingFreeViewHeaderRegestration(_ sections: [RecommandSection]) -> UICollectionView.SupplementaryRegistration<collectionViewHeaderView> {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }
    
    private func configRecommandDataSource(sections: [RecommandSection]) {
        guard let collectionView = rootView?.recommandView else {
            return
        }
        print(#function,"collectionView: ",collectionView)
        let headerRegistration = newWaitingFreeViewHeaderRegestration(sections)
        let cellRegistration = recommandCellRegistration()
        recommandDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        recommandDataSource?.supplementaryViewProvider = {(view, kind, index) in
            return self.rootView?.recommandView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func updateRecommandSnapShot(_ modelVector: [[PostsModel]], for sections: [RecommandSection]) {
        var snapShot = NSDiffableDataSourceSnapshot<RecommandSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            snapShot.appendItems(modelVector[section.rawValue], toSection: section)
        }
        recommandDataSource?.apply(snapShot)
    }
    
    //MARK: - 최근 본 작품 콜렉션 뷰
    private func recentlyCellRegistration() -> UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> {
        UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
    }
    
    private func recentlyViewHeaderRegestration(_ section: RecentlySection) -> UICollectionView.SupplementaryRegistration<collectionViewHeaderView> {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = section.header
        }
    }
    
    private func configRecentlyDataSource(section: RecentlySection) {
        guard let collectionView = rootView?.recentlyViewedView else {
            return
        }
        print(#function,"collectionView: ",collectionView)
        let headerRegistration = recentlyViewHeaderRegestration(section)
        let cellRegistration = recentlyCellRegistration()
        recentlyDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        recentlyDataSource?.supplementaryViewProvider = {(view, kind, index) in
            return self.rootView?.recentlyViewedView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func updateRecentlySnapShot(_ models: [PostsModel], for section: RecentlySection) {
        var snapShot = NSDiffableDataSourceSnapshot<RecentlySection, PostsModel>()
        snapShot.appendSections(RecentlySection.allCases)
        snapShot.appendItems(models, toSection: section)
        recentlyDataSource?.apply(snapShot)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, "collectionView: ", collectionView)
        print(#function, "indexPath: ", indexPath)
    }
}
