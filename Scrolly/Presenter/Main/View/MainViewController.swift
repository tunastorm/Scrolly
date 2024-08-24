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
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<collectionViewHeaderView>
   
    private let disposeBag = DisposeBag()
    
    // MARK: - CollectionView DiffableDataSources
    private var filterDataSource: UICollectionViewDiffableDataSource<HashTagSection, HashTagSection.HashTag>?
    private var recommandDataSource: UICollectionViewDiffableDataSource<RecommandSection, PostsModel>?

    override func configNavigationbar(navigationColor: UIColor, shadowImage: Bool, titlePosition: TitlePosition) {
        super.configNavigationbar(navigationColor: .white, shadowImage: false, titlePosition: .left)
        navigationItem.title = Resource.UIConstants.Text.appTitle
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
        
        configDataSource(sections: RecommandSection.allCases)
        output.recommandDatas
            .bind(with: self) { owner, resultList in
                let sections = RecommandSection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner.setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(dataDict)
            }
            .disposed(by: disposeBag)
//        //MARK: - 해시태그 필터 콜렉션 뷰
//        output.filterList
//            .bind(with: self) { owner, value in
//                owner.configFilterDataSource()
//                owner.updateFilterSnapShot(value)
//            }
//            .disposed(by: disposeBag)
//        
//        //MARK: - 추천 웹소설 콜렉션 뷰
//        configDataSource(sections: RecommandSection.allCases)
//        output.bannerList
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let model):
//                    let section: RecommandSection = .banner
//                    owner.configDataSource(sections: RecommandSection.allCases)
//                    owner.updateSnapShot([section.rawValue:model.data], for: [.banner])
//                    owner.rootView?.configBannerLabel(model.data.count)
//                case .failure(let error):
//                    owner.showToastToView(error)
//                }
//            }
//            .disposed(by: disposeBag)
//        
//        output.recomandDatas
//            .bind(with: self) { owner, results in
//                let sections: [RecommandSection] = [.popular, .newWaitingFree]
//                var dict: [String:[PostsModel]] = [:]
//                results.enumerated().forEach { idx, result in
//                    switch result {
//                    case .success(let model):
//                        dict[sections[idx].rawValue] = model.data
//                    case .failure(let error):
//                        owner.showToastToView(error)
//                    }
//                }
//                owner.updateSnapShot(dict, for: sections)
//            }
//            .disposed(by: disposeBag)
//        
//        output.recentlyList
//            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let model):
//                    let section: RecommandSection = .recently
//                    var viewed: [PostsModel] = []
//                    model.data.forEach { posts in
//                        if viewed.last?.hashTags.first == posts.hashTags.first {
//                            return
//                        }
//                        viewed.append(posts)
//                    }
//                    owner.updateSnapShot([section.rawValue:viewed], for: [section])
//                case .failure(let error):
//                    owner.showToastToView(error)
//                }
//            }.disposed(by: disposeBag)
    }
    
    private func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel] {
        var viewed: [PostsModel] = []
        postList.forEach { post in
            if viewed.last?.hashTags.first == post.hashTags.first {
                return
            }
            viewed.append(post)
        }
        return viewed
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
    
    //MARK: - 추천 콜렉션뷰
    private func recommandViewHeaderRegestration(_ sections: [RecommandSection]) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }
    
    private func configDataSource(sections: [RecommandSection]) {
        guard let collectionView = rootView?.recommandView else {
            return
        }
        let bannerCellRegistration = UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
        let recommandCellRegistration = UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
        
        let recentlyCellRegistration = UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
        let headerRegistration = recommandViewHeaderRegestration(sections)
        
        recommandDataSource = UICollectionViewDiffableDataSource<RecommandSection, PostsModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = RecommandSection.allCases[indexPath.section]
            switch section {
            case .banner:
                print(#function, "section: " , section)
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
                print(#function, "section: " , section)
                return collectionView.dequeueConfiguredReusableCell(using: recentlyCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        recommandDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.recommandView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
    }

    private func updateSnapShot(_ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<RecommandSection, PostsModel>()
        snapShot.appendSections(RecommandSection.allCases)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.rawValue] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        recommandDataSource?.apply(snapShot)
    }

    
//    //MARK: - 배너 콜렉션뷰
//    private func bannerCellRegistration() -> UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> {
//        UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
//            cell.configCell(itemIdentifier)
//        }
//    }
//    
//    private func configBannerDataSource() {
//        guard let collectionView = rootView?.bannerView else {
//            return
//        }
//        let cellRegistration = bannerCellRegistration()
//        bannerDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//    }
//    
//    private func updateBannerSnapShot(_ model: [PostsModel]) {
//        var snapShot = NSDiffableDataSourceSnapshot<BannerSection, PostsModel>()
//        snapShot.appendSections(BannerSection.allCases)
//        snapShot.appendItems(model, toSection: .main)
//        bannerDataSource?.apply(snapShot)
//    }
//    
//    //MARK: - 추천 콜렉션뷰
//    private func recommandCellRegistration() -> UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> {
//        UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
//            cell.configRecommandCell(itemIdentifier)
//        }
//    }
//    
//    private func newWaitingFreeViewHeaderRegestration(_ sections: [RecommandSection]) -> UICollectionView.SupplementaryRegistration<collectionViewHeaderView> {
//        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
//            (supplementaryView, string, indexPath) in
//            supplementaryView.titleLabel.text = sections[indexPath.section].header
//        }
//    }
//    
//    private func configRecommandDataSource(sections: [RecommandSection]) {
//        guard let collectionView = rootView?.recommandView else {
//            return
//        }
//        print(#function,"collectionView: ",collectionView)
//        let headerRegistration = newWaitingFreeViewHeaderRegestration(sections)
//        let cellRegistration = recommandCellRegistration()
//        recommandDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//        recommandDataSource?.supplementaryViewProvider = {(view, kind, index) in
//            return self.rootView?.recommandView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
//        }
//    }
//    
//    private func updateRecommandSnapShot(_ modelVector: [[PostsModel]], for sections: [RecommandSection]) {
//        var snapShot = NSDiffableDataSourceSnapshot<RecommandSection, PostsModel>()
//        snapShot.appendSections(sections)
//        snapShot.sectionIdentifiers.forEach { section in
//            snapShot.appendItems(modelVector[section.rawValue], toSection: section)
//        }
//        recommandDataSource?.apply(snapShot)
//    }
//    
//    //MARK: - 최근 본 작품 콜렉션 뷰
//    private func recentlyCellRegistration() -> UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> {
//        UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
//            cell.configCell(itemIdentifier)
//        }
//    }
//    
//    private func recentlyViewHeaderRegestration(_ section: RecentlySection) -> UICollectionView.SupplementaryRegistration<collectionViewHeaderView> {
//        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
//            (supplementaryView, string, indexPath) in
//            supplementaryView.titleLabel.text = section.header
//        }
//    }
//    
//    private func configRecentlyDataSource(section: RecentlySection) {
//        guard let collectionView = rootView?.recentlyViewedView else {
//            return
//        }
//        print(#function,"collectionView: ",collectionView)
//        let headerRegistration = recentlyViewHeaderRegestration(section)
//        let cellRegistration = recentlyCellRegistration()
//        recentlyDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        })
//        recentlyDataSource?.supplementaryViewProvider = {(view, kind, index) in
//            return self.rootView?.recentlyViewedView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
//        }
//    }
//    
//    private func updateRecentlySnapShot(_ models: [PostsModel], for section: RecentlySection) {
//        var snapShot = NSDiffableDataSourceSnapshot<RecentlySection, PostsModel>()
//        snapShot.appendSections(RecentlySection.allCases)
//        snapShot.appendItems(models, toSection: section)
//        recentlyDataSource?.apply(snapShot)
//    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, "collectionView: ", collectionView)
        print(#function, "indexPath: ", indexPath)
    }
}
