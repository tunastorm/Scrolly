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

final class EpisodeViewerView: BaseView, PDFViewDelegate {
    
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
    
    override func configHierarchy() {
        addSubview(pdfView)
    }
    
    
    override func configLayout() {
        pdfView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.left.equalToSuperview().offset(-120)
            make.right.equalToSuperview().offset(120)
        }
    }
    
    override func configView() {
        super.configView()
    }
    
    override func configInteractionWithViewController<T>(viewController: T) where T : UIViewController {
        guard let vc = viewController as? EpisodeViewerViewController else {
            return
        }
        
    }
    
    func configPDFView(_ document: PDFDocument) {
        pdfView.delegate = self
        pdfView.document = document
        let test = pdfView.onScrollOffsetChange { scrollView in
            print(#function, "움직이니?")
        }
    }
    
}


extension EpisodeViewerViewController: PDFDocumentDelegate {
    
    func documentDidEndPageFind(_ notification: Notification) {

    }
   
}

extension EpisodeViewerViewController: PDFViewDelegate {
    


}

