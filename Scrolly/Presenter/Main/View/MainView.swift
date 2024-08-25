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
    
//    private let collectionViewArea = UIView()
//    let recentlyViewedView = RecentlyViewedCollectionView(frame: .zero, collectionViewLayout: RecentlyViewedCollectionView.createLayout())
    
    private let bannerPageLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textColor = Resource.Asset.CIColor.white
        $0.textAlignment = .right
        $0.text = "1/"
    }
    
    private var lastCell: IndexPath?
    
//    private let scrollView = UIScrollView()
//    private let contentView = UIView()
//    
    override func configHierarchy() {
        addSubview(hashTagView)
        addSubview(recommandView)
//        addSubview(scrollView)
////        scrollView.addSubview(contentView)
////        [ bannerView, bannerPageLabel, recommandView, recentlyViewedView ].forEach {
////            contentView.addSubview($0)
////        }
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
        recommandView.snp.makeConstraints { make in
            make.top.equalTo(hashTagView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(hashTagView.snp.bottom).offset(10)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
//            make.bottom.equalTo(safeAreaLayoutGuide)
//        }
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView.contentLayoutGuide)
//            make.width.equalTo(scrollView.frameLayoutGuide)
//            make.height.equalTo(1600)
//        }
//        bannerView.snp.makeConstraints { make in
//            make.height.equalTo(350)
//            make.top.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()
//        }
//        bannerPageLabel.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.width.equalTo(80)
//            make.bottom.equalTo(bannerView.snp.bottom).offset(-20)
//            make.trailing.equalTo(bannerView.snp.trailing).offset(-32)
//        }
//        recommandView.snp.makeConstraints { make in
//            make.height.equalTo(1000)
//            make.top.equalTo(bannerView.snp.bottom).offset(10)
//            make.horizontalEdges.equalToSuperview().inset(12)
//        }
//        recentlyViewedView.snp.makeConstraints { make in
//            make.height.equalTo(210)
//            make.top.equalTo(recommandView.snp.bottom).offset(20)
//            make.leading.equalToSuperview().inset(12)
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview().inset(10)
//        }
        
    }
    
    override func configView() {
        super.configView()
        hashTagView.showsHorizontalScrollIndicator = false
        hashTagView.backgroundColor = .clear
        recommandView.backgroundColor = .clear
//        recommandView.showsVerticalScrollIndicator = false
//        recentlyViewedView.showsHorizontalScrollIndicator = false
//        recommandView.isScrollEnabled = false
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
