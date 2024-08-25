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
import Then

protocol HashTagCellDelegate {
    func changeRecentCell(_ indexPath: IndexPath)
}

final class MainView: BaseView {
    
    // MARK: - CollectionViews
    let hashTagView = HashTagCollectionView(frame: .zero, collectionViewLayout: HashTagCollectionView.createLayout())
//    let bannerView = BannerCollectionView(frame: .zero, collectionViewLayout: BannerCollectionView.createLayout())
    let recommandView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    
    let maleView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let femaleView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let fantasyView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let romanceView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let dateView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    
    lazy var collectionViewList = [ recommandView, maleView, femaleView, fantasyView, romanceView, dateView ]
//    lazy var pageLabelList = []
//    private let collectionViewArea = UIView()
//    let recentlyViewedView = RecentlyViewedCollectionView(frame: .zero, collectionViewLayout: RecentlyViewedCollectionView.createLayout())
    
    private let bannerPageLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textColor = Resource.Asset.CIColor.white
        $0.textAlignment = .right
        $0.text = "1/"
    }
    
    private var lastCell: IndexPath?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let pageControl = UIPageControl()
    
    override func configHierarchy() {
        addSubview(hashTagView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        collectionViewList.forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configLayout() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenSize = window.screen.bounds
        print(#function, "screenWidth: ", screenSize.width)
        hashTagView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(hashTagView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide).multipliedBy(collectionViewList.count)
            make.height.equalTo(scrollView.frameLayoutGuide)
        }
        recommandView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
        }
//        bannerPageLabel.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.width.equalTo(80)
//            make.bottom.equalTo(bannerView.snp.bottom).offset(-20)
//            make.trailing.equalTo(bannerView.snp.trailing).offset(-32)
//        }
        maleView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(recommandView.snp.trailing)
        }
        femaleView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(maleView.snp.trailing)
        }
        fantasyView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(femaleView.snp.trailing)
        }
        romanceView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(fantasyView.snp.trailing)
        }
        dateView.snp.makeConstraints { make in
            make.width.equalTo(screenSize.width)
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(romanceView.snp.trailing)
            make.trailing.equalToSuperview()
        }
        
    }
    
    override func configView() {
        super.configView()
        setPageControl()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
//              scrollView.delegate = self
        hashTagView.showsHorizontalScrollIndicator = false
        hashTagView.backgroundColor = .clear
        recommandView.backgroundColor = .clear
//        maleView.backgroundColor = .blue
//        femaleView.backgroundColor = .red
//        recommandView.showsVerticalScrollIndicator = false
//        recentlyViewedView.showsHorizontalScrollIndicator = false
//        recommandView.isScrollEnabled = false
    }
    
    
    final private func setPageControl() {
        pageControl.numberOfPages = collectionViewList.count
        pageControl.currentPage = 0
//        pageControl.page
//        pageControl.currentPageIndicatorTintColor = .darkGray
//        pageControl.pageIndicatorTintColor = .lightGray
    }
    
    override func configInteractionWithViewController<T: UIViewController >(viewController: T) {
        guard let mainVC = viewController as? MainViewController else {
            return
        }
//        popularView.delegate = mainVC
//        newWaitingFreeView.delegate = mainVC
//        bannerView.delegate = mainVC
    }
    
    func configBannerLabel(_ length: Int) {
        if let bannerPage = bannerPageLabel.text {
            bannerPageLabel.text = bannerPage + "\(length)"
        }
    }
    
}

extension MainView: HashTagCellDelegate {
    
    func changeRecentCell(_ indexPath: IndexPath) {
        let collectionView = hashTagView
        if let lastCell,let oldCell = collectionView.cellForItem(at: lastCell) as? HashTagCollectionViewCell {
            oldCell.isSelected.toggle()
            oldCell.cellTappedToggle()
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? HashTagCollectionViewCell else {
            return
        }
        print(#function, "왜???")
        
        cell.cellTappedToggle()
        lastCell = indexPath
    }
    
}

extension MainView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        pageControl.currentPage = currentPage

    }
    
}
