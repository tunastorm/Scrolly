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
    typealias DataSource<T: MainSection> = UICollectionViewDiffableDataSource<T, PostsModel>
    
    private let disposeBag = DisposeBag()
    
    // MARK: - CollectionView DiffableDataSources
    private var filterDataSource: UICollectionViewDiffableDataSource<HashTagSection, HashTagSection.HashTag>?
    private var recommandDataSource: DataSource<RecommandSection>?
    private var maleDataSource: DataSource<MaleSection>?
    private var femaleDataSource: DataSource<FemaleSection>?
    private var fantasyDataSource: DataSource<FantasySection>?
    private var romanceDataSource: DataSource<RomanceSection>?
    private var dateDataSource: DataSource<DateSection>?

    // MARK: - CellRegistrations
    private let bannerCellRegistration = UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    private let recommandCellRegistration = UICollectionView.CellRegistration<RecommandCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    private let recentlyCellRegistration = UICollectionView.CellRegistration<RecentlyCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
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
        
        configAllDataSoruces()
        
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
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
        
        output.maleDatas
            .bind(with: self) { owner, resultList in
                let sections = MaleSection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
        
        output.femaleDatas
            .bind(with: self) { owner, resultList in
                let sections = FemaleSection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
        
        output.fantasyDatas
            .bind(with: self) { owner, resultList in
                let sections = FantasySection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
        
        output.romanceDatas
            .bind(with: self) { owner, resultList in
                let sections = RomanceSection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
        
        output.dateDatas
            .bind(with: self) { owner, resultList in
                let sections = DateSection.allCases
                var dataDict: [String:[PostsModel]] = [:]
                resultList.enumerated().forEach { idx, result in
                    switch result {
                    case .success(let model):
                        let section = sections[idx]
                        if section == .banner {
                            owner.rootView?.configBannerLabel(model.data.count)
                        }
                        let data = section == .recently ? owner .setViewedNovel(model.data) : model.data
                        dataDict[section.rawValue] = data
                    case .failure(let error):
                        owner.showToastToView(error)
                    }
                }
                owner.updateSnapShot(sections: sections, dataDict)
            }
            .disposed(by: disposeBag)
    }
    
    private func configAllDataSoruces() {
        configDataSource(sections: RecommandSection.allCases)
        configDataSource(sections: MaleSection.allCases)
        configDataSource(sections: FemaleSection.allCases)
        configDataSource(sections: FantasySection.allCases)
        configDataSource(sections: RomanceSection.allCases)
        configDataSource(sections: DateSection.allCases)
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
        UICollectionView.CellRegistration<HashTagCollectionViewCell, HashTagSection.HashTag> { [weak self] cell, indexPath, itemIdentifier in
            cell.delegate = self?.rootView
            cell.configCell(indexPath,itemIdentifier)
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
    private func collectionViewHeaderRegestration<T: MainSection>(_ sections: [T]) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<collectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }
    
    private func configDataSource<T: MainSection>(sections: [T]) {
        
        let headerRegistration = collectionViewHeaderRegestration(sections)
        
        var collectionView: BaseCollectionViewController?
        switch sections {
        case is [RecommandSection]: collectionView = rootView?.recommandView
        case is [MaleSection]: collectionView = rootView?.maleView
        case is [FemaleSection]: collectionView = rootView?.femaleView
        case is [FantasySection]: collectionView = rootView?.fantasyView
        case is [RomanceSection]: collectionView = rootView?.romanceView
        case is [DateSection]: collectionView = rootView?.dateView
        default: break
        }
        
        guard let collectionView else {
            return
        }
        
        switch sections {
        case is [RecommandSection]: configRecommandDataSource(collectionView, headerRegistration)
        case is [MaleSection]: configMaleDataSource(collectionView, headerRegistration)
        case is [FemaleSection]: configFemaleDataSource(collectionView, headerRegistration)
        case is [FantasySection]: configFantasyDataSource(collectionView, headerRegistration)
        case is [RomanceSection]: configRomanceDataSource(collectionView, headerRegistration)
        case is [DateSection]: configDateDataSource(collectionView, headerRegistration)
        default: break
        }
    }
    
    private func configRecommandDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        recommandDataSource = UICollectionViewDiffableDataSource<RecommandSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = RecommandSection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
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
    
    private func configMaleDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        maleDataSource = UICollectionViewDiffableDataSource<MaleSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = MaleSection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
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
        maleDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.maleView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func configFemaleDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        femaleDataSource = UICollectionViewDiffableDataSource<FemaleSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = FemaleSection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
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
        femaleDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.femaleView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func configFantasyDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        fantasyDataSource = UICollectionViewDiffableDataSource<FantasySection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = FantasySection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
            switch section {
            case .banner:
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
                return collectionView.dequeueConfiguredReusableCell(using: recentlyCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
        fantasyDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.fantasyView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func configRomanceDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        romanceDataSource = UICollectionViewDiffableDataSource<RomanceSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = RomanceSection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
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
        romanceDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.romanceView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func configDateDataSource(_ collectionView: BaseCollectionViewController, _ headerRegistration: HeaderRegistration) {
        dateDataSource = UICollectionViewDiffableDataSource<DateSection, PostsModel>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = DateSection.allCases[indexPath.section]
            guard let bannerCellRegistration = self?.bannerCellRegistration,
                  let recommandCellRegistration = self?.recommandCellRegistration,
                    let recentlyCellRegistration = self?.recentlyCellRegistration else {
                return UICollectionViewCell()
            }
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
        dateDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.rootView?.dateView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }

    private func updateSnapShot<T: MainSection>(sections: [T], _ modelDict: [String:[PostsModel]]) {
        switch sections {
        case is [RecommandSection]: updateRecommandSnapshot(sections as? [RecommandSection] ?? [], modelDict)
        case is [MaleSection]: updateMaleSnapshot(sections as? [MaleSection] ?? [], modelDict)
        case is [FemaleSection]: updateFemaleSnapshot(sections as? [FemaleSection] ?? [], modelDict)
        case is [FantasySection]: updateFantasySnapshot(sections as? [FantasySection] ?? [], modelDict)
        case is [RomanceSection]: updateRomanceSnapshot(sections as? [RomanceSection] ?? [], modelDict)
        case is [DateSection]: updateDateSnapshot(sections as? [DateSection] ?? [], modelDict)
        default: break
        
        }
    }
    
    private func updateRecommandSnapshot(_ sections: [RecommandSection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<RecommandSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        recommandDataSource?.apply(snapShot)
    }
    
    private func updateMaleSnapshot(_ sections: [MaleSection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<MaleSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        maleDataSource?.apply(snapShot)
    }
    
    private func updateFemaleSnapshot(_ sections: [FemaleSection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<FemaleSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        femaleDataSource?.apply(snapShot)
    }
    
    private func updateFantasySnapshot(_ sections: [FantasySection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<FantasySection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        fantasyDataSource?.apply(snapShot)
    }
    
    private func updateRomanceSnapshot(_ sections: [RomanceSection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<RomanceSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        romanceDataSource?.apply(snapShot)
    }
    
    private func updateDateSnapshot(_ sections: [DateSection], _ modelDict: [String:[PostsModel]]) {
        var snapShot = NSDiffableDataSourceSnapshot<DateSection, PostsModel>()
        snapShot.appendSections(sections)
        snapShot.sectionIdentifiers.forEach { section in
            guard let models = modelDict[section.value] else { return }
            snapShot.appendItems(models, toSection: section)
        }
        dateDataSource?.apply(snapShot)
    }

}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, "collectionView: ", collectionView)
        print(#function, "indexPath: ", indexPath)
    }
}
