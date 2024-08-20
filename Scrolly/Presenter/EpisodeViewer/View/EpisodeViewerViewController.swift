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

final class EpisodeViewerViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    lazy var pdfView = {
        let view = PDFView()
        view.autoScales = true
        view.backgroundColor = .white
        view.displayMode = .singlePage
        view.displayDirection = .horizontal
        view.pageShadowsEnabled = false
        view.usePageViewController(true, withViewOptions: nil)
        view.maxScaleFactor = 1.0
        view.minScaleFactor = 2.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.bounds
    }

    private func configureHierarchy() {
        view.addSubview(pdfView)
    }
    
    private func configureLayout() {
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
//        navigationController?.hidesBarsOnTap = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pdfViewTapped)))
        pdfView.delegate = self
        queryOnePost(postId: "66c35fc6d22f9bf13229215d")
    }

    
    private func testSubscribe(single: Single<APIManager.ModelResult>) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let model):
                print(#function, "model: ")
                dump(model)
                let postModel = model as! PostsModel
                
                guard let pdf = postModel.files.last else {
                    print("PDF 없음 ")
                    return
                }
                
                owner.navigationItem.title = postModel.title
                owner.getPostFile(file: pdf)
            case .failure(let error):
                print(#function, "error: ", error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func pdfViewSubscribe(single: Single<APIManager.DataResult>) {
        single.subscribe(with: self) { owner, result in
            switch result {
            case .success(let data):
                guard let document = PDFDocument(data: data) else { return }
                document.delegate = self
                owner.pdfView.document = document
            case .failure(let error):
                print(#function, "error: ", error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func queryOnePost(postId: String) {
        let result = APIManager.shared.callRequestAPI(model: PostsModel.self, router: .queryOnePosts(postId))
        testSubscribe(single: result)
    }
    
    private func getPostFile(file: String) {
        let result = APIManager.shared.callRequestData(.getPostsImage(file))
        pdfViewSubscribe(single: result)
    }
    
    @objc private func pdfViewTapped(_ sender: UITapGestureRecognizer) {
        guard let isHidden = navigationController?.navigationBar.isHidden else {
            return
        }
        navigationController?.navigationBar.setHidden(!isHidden, animated: true)
    }
    
    
}

extension EpisodeViewerViewController: PDFDocumentDelegate {
    
   
   
}

extension EpisodeViewerViewController: PDFViewDelegate {
    
    
    
}
