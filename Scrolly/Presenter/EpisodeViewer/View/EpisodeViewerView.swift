//
//  EpisodeViewerView.swift
//  Scrolly
//
//  Created by 유철원 on 8/29/24.
//

import UIKit
import PDFKit
import SnapKit
import Then

final class EpisodeViewerView: BaseView {
    
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
    
    private func configureHierarchy() {
        addSubview(pdfView)
    }
    
    private func configureLayout() {
        pdfView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(-120)
            make.right.equalToSuperview().offset(120)
        }
    }
    
    private func configureView() {
       
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        guard let vc = viewController as? EpisodeViewerViewController else {
            return
        }
        pdfView.delegate = vc
    }
    
    func configPDFView(_ document: PDFDocument) {
        print("pageCount: ", document.pageCount)
        pdfView.document = document
    }
    
}
