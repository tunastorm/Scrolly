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

protocol MainViewDelegate {
    func emitFromScrollView(_ indexPath: IndexPath)
}

final class MainViewController: BaseViewController<MainView> {
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>
    typealias NovelDataSource<T: MainSection> = UICollectionViewDiffableDataSource<T, PostsModel>
    
    private let disposeBag = DisposeBag()
    
    // MARK: - CollectionView DiffableDataSources
    private var filterDataSource: UICollectionViewDiffableDataSource<HashTagSection, HashTagSection.HashTag>?
    private var recommandDataSource: NovelDataSource<RecommandSection>?
    private var maleDataSource: NovelDataSource<MaleSection>?
    private var femaleDataSource: NovelDataSource<FemaleSection>?
    private var fantasyDataSource: NovelDataSource<FantasySection>?
    private var romanceDataSource: NovelDataSource<RomanceSection>?
    private var dateDataSource: NovelDataSource<DateSection>?

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
    
    private let scrollViewPaging = PublishRelay<IndexPath>()
    
    override func loadView() {
        super.loadView()
        rootView?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.isHidden = true
        navigationItem.backBarButtonItem?.isEnabled = false
    }
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: .white, shadowImage: false, foregroundColor: Resource.Asset.CIColor.blue, titlePosition: .left)
        navigationItem.title = Resource.UIConstants.Text.appTitle
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func bindData() {

        guard let mainViewModel = viewModel as? MainViewModel, let rootView else {
            return
        }
        
        rootView.collectionViewList.enumerated().forEach { idx, collectionView in
            rxPushToDetailViewController(dataSource: idx, from: collectionView)
        }
        
        let input = MainViewModel.Input(hashTagCellTap: rootView.hashTagView.rx.itemSelected, srollViewPaging: scrollViewPaging)
        guard let output = mainViewModel.transform(input: input) else {
            return
        }
        
        output.filterList
            .bind(with: self) { owner, values in
                owner.configFilterDataSource()
                owner.updateFilterSnapShot(values)
            }
            .disposed(by: disposeBag)
    
        output.recommandDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: RecommandSection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
        
        output.maleDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: MaleSection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
        
        output.femaleDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: FemaleSection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
        
        output.fantasyDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: FantasySection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
        
        output.romanceDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: RomanceSection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
        
        output.dateDatas
            .bind(with: self) { owner, resultList in
                owner.fetchDatas(sections: DateSection.allCases, resultList: resultList)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchDatas<T: MainSection>(sections: [T], resultList: [APIManager.ModelResult<GetPostsModel>]) {
        var dataDict: [String:[PostsModel]] = [:]
        var noDataSection: T?
        resultList.enumerated().forEach { idx, result in
            switch result {
            case .success(let model):
                if model.data.count == 0 {
                    noDataSection = sections[idx]
                    return
                }
                let section = sections[idx]
                dataDict[section.value] = section.callConvertData(section, model.data)
            case .failure(let error):
               showToastToView(error)
            }
        }
        configDataSource(sections: sections, noDataSection: noDataSection)
        updateSnapShot(sections: sections, dataDict)
    }
    
    private func rxPushToDetailViewController(dataSource idx: Int, from collectionView: BaseCollectionViewController) {
    
        collectionView.rx.itemSelected
            .bind(with: self) { [weak self] owner, indexPath in
                let dataSource = HashTagSection.HashTag.allCases[idx]
                let model = self?.getModel(from: dataSource, indexPath)
                let vc = NovelDetailViewController(view: NovelDetailView(), viewModel: NovelDetailViewModel(detailInfo: model))
                owner.pushAfterView(view: vc, backButton: true, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func getModel(from dataSource: HashTagSection.HashTag, _ indexPath: IndexPath) -> PostsModel? {
        var post: PostsModel?
        switch dataSource {
        case .recommand: post = recommandDataSource!.itemIdentifier(for: indexPath)
        case .male: post = maleDataSource!.itemIdentifier(for: indexPath)
        case .female: post = femaleDataSource!.itemIdentifier(for: indexPath)
        case .fantasy: post = fantasyDataSource!.itemIdentifier(for: indexPath)
        case .romance: post = romanceDataSource!.itemIdentifier(for: indexPath)
        case .day: post = dateDataSource!.itemIdentifier(for: indexPath)
        }
        return post
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
    private func collectionViewHeaderRegestration<T: MainSection>(_ sections: [T], _ noDataSection: T?) -> HeaderRegistration {
        UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            if let noDataSection, sections[indexPath.section] == noDataSection {
                return
            }
            supplementaryView.titleLabel.text = sections[indexPath.section].header
        }
    }
    
    private func configDataSource<T: MainSection>(sections: [T], noDataSection: T?) {
        
        let headerRegistration = collectionViewHeaderRegestration(sections, noDataSection)
        
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
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
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
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
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
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
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
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
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
                return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: itemIdentifier)
            case .popular, .newWaitingFree:
                return collectionView.dequeueConfiguredReusableCell(using: recommandCellRegistration, for: indexPath, item: itemIdentifier)
            case .recently:
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
        rootView?.changeRecentCell(indexPath, isSelected: true, isClicked: true)
    }

}

extension MainViewController: MainViewDelegate {
    
    func emitFromScrollView(_ indexPath: IndexPath) {
        scrollViewPaging.accept(indexPath)
    }
    
}
