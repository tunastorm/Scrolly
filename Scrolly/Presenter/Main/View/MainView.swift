//
//  MainView.swift
//  Scrolly
//
//  Created by 유철원 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainView: BaseView {
    
    // MARK: - DataSources
    private var filterDataSource: UICollectionViewDiffableDataSource<HashTagSection, HashTagSection.HashTag>?
    private var bannerDataSource: UICollectionViewDiffableDataSource<BannerSection, PostsModel>?
    
    // MARK: - CollectionViews
    private let hashTagView = HashTagCollectionView(frame: .zero, collectionViewLayout: HashTagCollectionView.createLayout())
    private let bannerView = BannerCollectionView(frame: .zero, collectionViewLayout: BannerCollectionView.createLayout())
    private let popularView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    
    private let recentlyViewedView = RecentlyViewedCollectionView(frame: .zero, collectionViewLayout: RecentlyViewedCollectionView.createLayout())
    
    private let newWaitingFreeView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func configHierarchy() {
        addSubview(hashTagView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [ bannerView, popularView , recentlyViewedView, newWaitingFreeView ].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configLayout() {
        hashTagView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(hashTagView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1404)
        }
        bannerView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        popularView.snp.makeConstraints { make in
            make.height.equalTo(404)
            make.top.equalTo(bannerView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        recentlyViewedView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.top.equalTo(popularView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview()
        }
        newWaitingFreeView.snp.makeConstraints { make in
            make.height.equalTo(404)
            make.width.equalTo(350)
            make.top.equalTo(recentlyViewedView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    override func configView() {
        backgroundColor = .white
        hashTagView.showsHorizontalScrollIndicator = false
        bannerView.showsHorizontalScrollIndicator = false
        popularView.backgroundColor = .systemBlue
        recentlyViewedView.backgroundColor = .systemBlue
        newWaitingFreeView.backgroundColor = .systemBlue
    }
    
    override func configInteractionWithViewController<T: UIViewController >(viewController: T) {
        guard let mainVC = viewController as? MainViewController else {
            return
        }
        bannerView.delegate = mainVC
    }
    
    func configHashTagView(_ hashTags: [HashTagSection.HashTag]) {
        configFilterDataSource()
        updateFilterSnapShot(hashTags)
    }
    
    func configBannerView(_ model: [PostsModel]) {
        configBannerDataSource()
        updateBannerSnapShot(model)
        
    }

}

extension MainView {
    
    //MARK: - 해시태그 필터 콜렉션뷰 구현부
    private func filterCellRegistration() -> UICollectionView.CellRegistration<HashTagCollectionViewCell, HashTagSection.HashTag> {
        UICollectionView.CellRegistration<HashTagCollectionViewCell, HashTagSection.HashTag> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
    }
    
    private func configFilterDataSource() {
         let collectionView = hashTagView
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
    
    //MARK: - 배너 콜렉션뷰 구현부
    private func bannerCellRegistration() -> UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> {
        UICollectionView.CellRegistration<BannerCollectionViewCell, PostsModel> { cell, indexPath, itemIdentifier in
            cell.configCell(itemIdentifier)
        }
    }
    
    private func configBannerDataSource() {
         let collectionView = bannerView
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
    
}
