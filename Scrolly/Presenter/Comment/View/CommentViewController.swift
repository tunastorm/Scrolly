//
//  CommentView.swift
//  Scrolly
//
//  Created by 유철원 on 9/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol CommentViewDelegate {
    
    func dissmissCommentView()
    
    func uploadComment(_ comment: String)
    
}


protocol CommentCellDelegate {
    
}

final class CommentViewController: BaseViewController<CommentView> {
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>
    typealias CellRegistration<T: BaseCollectionViewCell> = UICollectionView.CellRegistration<T, Comment>
    
    private var returnSelf: Self {
        return self
    }
    
    private let disposeBag = DisposeBag()
    
    private var headerRegistration: HeaderRegistration?
    
    private func collectionViewHeaderRegestration(_ sections: [CommentSectionModel]) -> HeaderRegistration {
        HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = CommentSection.allCases[indexPath.section].header
            
            if CommentSection.allCases[indexPath.section] == .comments {
                supplementaryView.titleLabel.text! += " \(sections[indexPath.section].items.count)"
                supplementaryView.commentCellLayout()
            }
            
        }
    }
    
    private let commentCellRegistration = CellRegistration<CommentCell> { cell, indexPath, itemIdentifier in
        cell.configCell(itemIdentifier)
    }

    private lazy var commentDataSource = RxCollectionViewSectionedAnimatedDataSource<CommentSectionModel> (
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            let section = CommentSection.allCases[indexPath.section]
            print(#function, "section: ", section)
            if section == .comments, let cellRegistration = self?.commentCellRegistration {
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
    
    private let input = CommentViewModel.Input(comment: PublishSubject<String>(), newModel: PublishSubject<Void>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView?.layoutIfNeeded()
    }
    
    override func bindData() {
        guard let rootView, let viewModel = viewModel as? CommentViewModel else {
            return
        }
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        print(#function, "output: ", output)
        output.title
            .debug("output - title")
            .bind(with: self) { owner, title in
                owner.rootView?.configTitle(title)
            }
            .disposed(by: disposeBag)
        
        output.comments
            .debug("output - comments")
            .map { [weak self] comments in
                print(#function, "comments: ", comments)
                let headerView = CollectionViewHeaderView()
                let sectionList = [CommentSectionModel(header: headerView, items: comments)]
                self?.headerRegistration = self?.collectionViewHeaderRegestration(sectionList)
                return sectionList
            }
            .bind(to: rootView.collectionView.rx.items(dataSource: commentDataSource))
            .disposed(by: disposeBag)
            
    }
    
}

extension CommentViewController: CommentViewDelegate {
  
    func dissmissCommentView() {
        dismiss(animated: true)
    }

    func uploadComment(_ comment: String) {
        input.comment.onNext(comment)
    }
    
}

extension CommentViewController: CommentCellDelegate {
    
}
