//
//  PaymentView.swift
//  Scrolly
//
//  Created by 유철원 on 8/30/24.
//

import UIKit
import SnapKit
import Then
import WebKit

final class PaymentView: BaseView {
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func configHierarchy() {
        addSubview(wkWebView)
    }
    
    override func configLayout() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        super.configView()
    }
    
}



