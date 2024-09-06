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
    
    var delegate: EpisodeViewerViewDelegate?
    
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
    
    private var pageDict: [String:Int] = [:]
    
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
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAtLastPage))
        addGestureRecognizer(swipe)
        
    }
    
    func configPDFView(_ document: PDFDocument) {
        pageDict["maxPage"] = document.pageCount
        pdfView.document = document
    }
    
    //        NotificationCenter.default.addObserver (self, selector: #selector(pageChanged), name: Notification.Name.PDFViewPageChanged, object: nil)
//    @objc private func pageChanged() {
//        guard let current = pdfView.currentPage else {
//            return
//        }
//        let currentPage = current.pageRef?.pageNumber
//        pageDict["currentPage"] = currentPage
//    }
//    
    @objc private func swipeAtLastPage(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print(#function, "스와이프 됨")
            guard let last = pageDict["lastPage"], let current = pageDict["currentPage"] else {
                return
            }
            if current == last {
                print(#function, "가즈아!")
                delegate?.pushToEpisodeEndViewController()
            }
        }
    }
    
}
