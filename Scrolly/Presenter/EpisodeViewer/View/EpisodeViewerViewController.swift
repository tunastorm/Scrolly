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

final class EpisodeViewerViewController: BaseViewController<EpisodeViewerView> {
    
    private var lastPage: Int?
    
    private let disposeBag = DisposeBag()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configInteraction() {
        rootView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        rootView?.configInteractionWithViewController(viewController: self)
    }
    
    override func configNavigationbar(backgroundColor: UIColor, backButton: Bool, shadowImage: Bool, foregroundColor: UIColor, barbuttonColor: UIColor, titlePosition: TitlePosition) {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
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
                    document.delegate = self
                    owner.rootView?.configPDFView(document)
//                    owner.pdfView.document = document
                case .failure(let error):
                    print(#function, "error: ", error)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let isHidden = navigationController?.navigationBar.isHidden else {
            return
        }
        navigationController?.navigationBar.setHidden(!isHidden, animated: true)
        UINavigationBar.appearance().isTranslucent = !isHidden
    }
    
}
