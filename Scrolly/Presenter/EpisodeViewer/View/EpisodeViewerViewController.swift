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

    private let disposeBag = DisposeBag()
    
    private let pdfView = {
        let view = PDFView()
        view.backgroundColor = .white
        view.displayMode = .singlePage
        view.displayDirection = .horizontal
        view.pageShadowsEnabled = false
        view.usePageViewController(true, withViewOptions: nil)
        view.maxScaleFactor = 0.5
        view.minScaleFactor = 1.0
        return view
    }()
    
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
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(-120)
            make.right.equalToSuperview().offset(120)
        }
        
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
                    owner.pdfView.document = document
                case .failure(let error):
                    print(#function, "error: ", error)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
//    private func testSubscribe(single: Single<APIManager.ModelResult<PostsModel>>) {
//        single.subscribe(with: self) { owner, result in
//            switch result {
//            case .success(let model):
//                guard let pdf = model.files.last else {
//                    return
//                }
//                owner.navigationItem.title = model.title
//                owner.getPostFile(file: pdf)
//            case .failure(let error):
//                print(#function, "error: ", error)
//            }
//        }
//        .disposed(by: disposeBag)
//    }
//    
//    private func pdfViewSubscribe(single: Single<APIManager.DataResult>) {
//        single.subscribe(with: self) { owner, result in
//            switch result {
//            case .success(let data):
//                guard let document = PDFDocument(data: data) else { return }
//                document.delegate = self
//                print("pageCount: ", document.pageCount)
//                owner.rootView?.pdfView.document = document
//            case .failure(let error):
//                print(#function, "error: ", error)
//            }
//        }
//        .disposed(by: disposeBag)
//    }
//    
//    private func queryOnePost(postId: String) {
//        let result = APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId))
//        testSubscribe(single: result)
//    }
//    
//    private func getPostFile(file: String) {
//        let result = APIManager.shared.callRequestData(.getPostsImage(file))
//        pdfViewSubscribe(single: result)
//    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let isHidden = navigationController?.navigationBar.isHidden else {
            return
        }
        navigationController?.navigationBar.setHidden(!isHidden, animated: true)
        UINavigationBar.appearance().isTranslucent = !isHidden
    }
    
}

extension EpisodeViewerViewController: PDFDocumentDelegate {
    
   
   
}

extension EpisodeViewerViewController: PDFViewDelegate {
    

}
