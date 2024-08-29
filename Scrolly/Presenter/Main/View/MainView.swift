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
    func changeRecentCell(_ indexPath: IndexPath, isSelected: Bool, isClicked: Bool)
}

final class MainView: BaseView {
    
    var delegate: MainViewDelegate?
    
    private var screenSize: CGRect?
    private let disposeBag = DisposeBag()
    
    // MARK: - CollectionViews
    let hashTagView = HashTagCollectionView(frame: .zero, collectionViewLayout: HashTagCollectionView.createLayout())
    let recommandView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let maleView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let femaleView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let fantasyView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let romanceView = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    let dateView
    = RecommandCollectionView(frame: .zero, collectionViewLayout: RecommandCollectionView.createLayout())
    
    lazy var collectionViewList = [ recommandView, maleView, femaleView, fantasyView, romanceView, dateView ]
    
    private let bannerPageLabel = UILabel().then {
        $0.font = Resource.Asset.Font.boldSystem13
        $0.textColor = Resource.Asset.CIColor.white
        $0.textAlignment = .right
        $0.text = "1/"
    }
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let pageControl = UIPageControl()
    
    var lastCell = IndexPath(item: 0, section: 0)
    
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
        screenSize = window.screen.bounds
        guard let screenSize else {
            return
        }
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
    }
    
    final private func setPageControl() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        pageControl.numberOfPages = collectionViewList.count
        pageControl.currentPage = 0
    }
    
    
    override func configInteractionWithViewController<T: UIViewController >(viewController: T) {
        guard let mainVC = viewController as? MainViewController else {
            return
        }
        hashTagView.delegate = mainVC
        print(#function, "하이")
    }

}

extension MainView: HashTagCellDelegate {
    
    func changeRecentCell(_ indexPath: IndexPath, isSelected: Bool, isClicked: Bool = false) {
        let collectionView = hashTagView
        if let oldCell = collectionView.cellForItem(at: lastCell) as? HashTagCollectionViewCell {
            oldCell.isSelected = !isSelected
            oldCell.cellTappedToggle()
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? HashTagCollectionViewCell else {
            return
        }
    
        if isClicked {
            scrollToClickedFilter(item: Double(indexPath.item))
        } else {
            cell.isSelected = isSelected
        }
        cell.cellTappedToggle()
        lastCell = indexPath
    }
    
    func scrollToClickedFilter(item: Double) {
        guard let screenSize else {
            return
        }
        let startOffset = Double(screenSize.size.width) * item
        let view = CGRect(origin: .init(x: startOffset, y: 0), size: .init(width: screenSize.width, height: scrollView.frame.height))
        scrollView.scrollRectToVisible(view, animated: true)
    }
    
}

extension MainView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        pageControl.currentPage = currentPage
    }
    // 인덱스 조작해서 현재 페이지 구하는데 안전할까?
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var item: Int
        switch scrollView.scrollDirection {
        case .next: item = pageControl.currentPage + 1
        case .previous: item = pageControl.currentPage
        default: return
        }
        let indexPath = IndexPath(item: item, section: 0)
        delegate?.emitFromScrollView(indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        changeRecentCell(indexPath, isSelected: true)
        hashTagView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
