//
//  EpisodeViewerViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import UIKit
import PDFKit
import RxSwift
import SnapKit

protocol EpisodeViewerViewDelegate {
    func pushToEpisodeEndViewController()
}

final class EpisodeViewerViewController: BaseViewController<EpisodeViewerView> {
    
    private var lastPage: Int?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configInteraction() {
        rootView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool = true, shadowImage: Bool, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.white, backButton: true, shadowImage: false)
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = textAttributes
     
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isHidden = false
        navigationController?.isToolbarHidden = false
        navigationItem.backButtonTitle = ""
        configToolbar() 
    }
    
    override func bindData() {
        
        guard let viewModel = viewModel as? EpisodeViewerViewModel, let rootView else {
            return
        }
        let input = EpisodeViewerViewModel.Input()
        guard let output = viewModel.transform(input: input) else {
            return
        }
        
        output.title
            .bind(with: self) { owner, title in
                owner.navigationItem.title = title
            }
            .disposed(by: disposeBag)
        
        output.model
            .bind(with: self) { owner, result in
                switch result {
                case .success(let data):
                    guard let document = PDFDocument(data: data) else {
                        return
                    }
                    owner.rootView?.configPDFView(document)
                case .failure(let error):
                    owner.showToastToView(error)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configToolbar() {
        let appearance = UIToolbarAppearance()
        appearance.backgroundColor = Resource.Asset.CIColor.white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        
        let likeButton = UIBarButtonItem(image: Resource.Asset.SystemImage.heart, style: .plain, target: self, action: #selector(likeButtonTapped))
        likeButton.tintColor = Resource.Asset.CIColor.black
        
        let commentButton = UIBarButtonItem(image: Resource.Asset.SystemImage.message, style: .plain, target: self, action: #selector(commentsButtonTapped))
        commentButton.tintColor = Resource.Asset.CIColor.black
        
        let nextButton = UIBarButtonItem(image: Resource.Asset.SystemImage.chevronRight, style: .plain, target: self, action: #selector(nextButtonTapped))
        
        nextButton.tintColor = Resource.Asset.CIColor.black
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        self.toolbarItems = [ spacer, commentButton, spacer, likeButton, spacer, nextButton, spacer ]
    }
    
    @objc private func likeButtonTapped() {
        print("좋아요 클릭됨")
    }
    
    @objc private func commentsButtonTapped() {
        print("댓글 클릭됨")
    }
    
    @objc private func nextButtonTapped() {
        let vc = EpisodeEndViewController(view: EpisodeEndView(), viewModel: EpisodeEndViewModel())
        pushAfterView(view: vc, backButton: true, animated: true)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let isHidden = navigationController?.navigationBar.isHidden else {
            return
        }
        navigationController?.navigationBar.setHidden(!isHidden, animated: true)
        navigationController?.toolbar.setHidden(!isHidden, animated: true)
        UINavigationBar.appearance().isTranslucent = !isHidden
    }
    
}

extension EpisodeViewerViewController: EpisodeViewerViewDelegate {
    
    func pushToEpisodeEndViewController() {
        
    }
    
}
