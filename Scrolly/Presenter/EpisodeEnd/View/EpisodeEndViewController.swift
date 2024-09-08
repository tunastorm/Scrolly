//
//  EpisodeEndViewController.swift
//  Scrolly
//
//  Created by 유철원 on 9/1/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol EpisodeEndViewDelegate {
    
    func presentCommentViewController()
    
}

final class EpisodeEndViewController: BaseViewController<EpisodeEndView> {
    
    private let disposeBag = DisposeBag()
    
    override func configInteraction() {
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func configNavigationbar(backgroundColor: UIColor = .clear, backButton: Bool = true, shadowImage: Bool = false, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.white)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func bindData() {
        guard let viewModel = viewModel as? EpisodeEndViewModel else {
            return
        }
        let input = EpisodeEndViewModel.Input()
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        output.episodeInfo
            .debug("output - episodeInfo")
            .bind(with: self) { owner, model in
                owner.rootView?.configData(model)
            }
            .disposed(by: disposeBag)
    }
    
}

extension EpisodeEndViewController: EpisodeEndViewDelegate {
    
    func presentCommentViewController() {
        let vc = CommentViewController(view: CommentView(), viewModel: CommentViewModel(model: viewModel?.model))
        present(vc, animated: true)
    }
    
}
