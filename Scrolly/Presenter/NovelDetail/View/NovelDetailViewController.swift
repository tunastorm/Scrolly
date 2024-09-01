//
//  NovelDetailViewContreoller.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit
import Differentiator
import iamport_ios
import RxSwift
import RxCocoa
import RxDataSources

enum NovelViewedNotification {
    static let viewed = "NovelViewed"
}


protocol NovelDetailViewDelegate {
    
    func getModel() -> PostsModel?
    
    func popToMainViewController()
    
    func pushToProfileViewController()
    
}
 
protocol EpisodeCellDelegate {
    
    func showIamportAlert(_ indexPath: IndexPath)
    
    func pushToViewer(_ indexPath: IndexPath)
    
    func pushToPaymentView(_ indexPath: IndexPath)
}


final class NovelDetailViewController: BaseViewController<NovelDetailView> {

    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>
    typealias CellRegistration<T: BaseCollectionViewCell> = UICollectionView.CellRegistration<T, PostsModel>
    
    private var returnSelf: Self {
        return self
    }
    
    private let disposeBag = DisposeBag()
    
    private let descriptionCellRegistration = CellRegistration<DescriptionCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let infoCellRegistration = CellRegistration<InfoCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }
    
    private let episodeCellRegistration = CellRegistration<EpisodeCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier, indexPath: indexPath)
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
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                cell.delegate = self?.returnSelf
                return cell
            }
            return UICollectionViewCell()
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let headerRegistration = self?.headerRegistration else {
                return UICollectionReusableView()
            }
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    )

    
    private let input = NovelDetailViewModel.Input(viewedNovel: PublishSubject<PostsModel>(), viewedList: BehaviorSubject(value: ()))
    
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
        guard let output = detailViewModel.transform(input: input) else {
            return
        }
    
        PublishSubject<[NovelDetailSectionModel]>
            .combineLatest(output.fetchedModel, output.episodes, output.viewedList) { [weak self] novel, episodes, viewedList in
                let headerView = CollectionViewHeaderView()
                var sectionList = [
                    NovelDetailSectionModel(header: headerView, items: []),
                    NovelDetailSectionModel(header: headerView, items: [])
                ]
                guard let episodes = self?.fetchPostsModelList(episodes),
                      let viewedList = self?.fetchPostsModelList(viewedList) else {
                    return sectionList
                }
                guard let fetchedEpisodes = self?.fetchViewedListToEpisode(episodes, viewedList) else {
                    return sectionList
                }
                self?.headerRegistration = self?.collectionViewHeaderRegestration(sectionList)
                sectionList[0].items = [novel]
                sectionList[1].items = fetchedEpisodes
                return sectionList
            }
            .bind(to: rootView.collectionView.rx.items(dataSource: detailDataSource))
            .disposed(by: disposeBag)
    }
    
    private func fetchPostsModelList(_ episodes: APIManager.ModelResult<GetPostsModel>) -> [PostsModel] {
        var list: [PostsModel] = []
        switch episodes {
        case .success(let model):
            list = sortingPostsModels(list: model.data)
        case .failure(let error):
            showToastToView(error)
            return list
        }
        return list
    }
    
    private func sortingPostsModels(list: [PostsModel], accending: Bool = false) -> [PostsModel] {
        return list.sorted {
            if let left = Int($0.content1 ?? ""), let right = Int($1.content1  ?? "") {
                return accending == true ? left < right : left > right
            }
            return false
        }
    }
    
    private func fetchViewedListToEpisode(_ episodeList: [PostsModel], _ viewedList: [PostsModel]) -> [PostsModel] {
        var fetchedList = episodeList
        let viewedIds = viewedList.map { $0.postId }
        episodeList.enumerated().forEach { idx, episode in
            if viewedIds.contains(episode.postId) {
                fetchedList[idx].content4 = "true"
            }
        }
        return fetchedList
    }
    
//    private func configToolbar() {
//        let appearance = UIToolbarAppearance()
//        appearance.backgroundColor = Resource.Asset.CIColor.white
//        appearance.shadowImage = UIImage()
//        appearance.shadowColor = .clear
//        navigationController?.toolbar.scrollEdgeAppearance = appearance
//        
//        let likeButton = UIBarButtonItem(image: Resource.Asset.SystemImage.heart, style: .plain, target: self, action: #selector(likeButtonTapped))
//        likeButton.tintColor = Resource.Asset.CIColor.black
//        
//        let commentButton = UIBarButtonItem(image: Resource.Asset.SystemImage.message, style: .plain, target: self, action: #selector(commentsButtonTapped))
//        commentButton.tintColor = Resource.Asset.CIColor.black
//        
//        let nextButton = UIBarButtonItem(image: Resource.Asset.SystemImage.chevronRight, style: .plain, target: self, action: #selector(nextButtonTapped))
//        
//        nextButton.tintColor = Resource.Asset.CIColor.black
//        
//        navigationController?.toolbarItems = [ nextButton, likeButton, commentButton ]
//    }
//    
//    @objc private func likeButtonTapped() {
//        print("좋아요 클릭됨")
//    }
//    
//    @objc private func commentsButtonTapped() {
//        print("댓글 클릭됨")
//    }
//    
//    @objc private func nextButtonTapped() {
//        let vc = EpisodeEndViewController(view: EpisodeEndView(), viewModel: EpisodeEndViewModel())
//        pushAfterView(view: vc, backButton: true, animated: true)
//    }

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

extension NovelDetailViewController: EpisodeCellDelegate {
    
    func showIamportAlert(_ indexPath: IndexPath) {
        let title = PaymentStatus.AlertTitle
        let message = PaymentStatus.AlertMessage
        showAlert(style: .alert, title: title, message: message) { [weak self] UIAlertAction in
            self?.pushToPaymentView(indexPath)
        }
    }
    
    func pushToViewer(_ indexPath: IndexPath) {
        do {
            guard let model = try detailDataSource.model(at: indexPath) as? PostsModel else {
                return
            }
            input.viewedNovel.onNext(model)
            input.viewedList.onNext(())
            NotificationCenter.default.post(name: NSNotification.Name(NovelViewedNotification.viewed), object: nil, userInfo: nil)
//            configToolbar()
            let vc = EpisodeViewerViewController(view: EpisodeViewerView(), viewModel: EpisodeViewerViewModel(novel: model))
            pushAfterView(view: vc, backButton: true, animated: true)
        } catch {
            return
        }
    
    }
    
    func pushToPaymentView(_ indexPath: IndexPath) {
        do {
            guard let model = try detailDataSource.model(at: indexPath) as? PostsModel else {
                return
            }
            let vc = PaymentViewController(view: PaymentView())
            vc.model = model
            vc.complitionHandler = { [weak self] in
                self?.input.viewedNovel.onNext(model)
                self?.popBeforeView(animated: false)
                let viewer = EpisodeViewerViewController(view: EpisodeViewerView(), viewModel: EpisodeViewerViewModel(novel: model))
                self?.pushAfterView(view: viewer, backButton: true, animated: true)
            }
            pushAfterView(view: vc, backButton: true, animated: true)
        } catch {
            return
        }
    }
    
}
