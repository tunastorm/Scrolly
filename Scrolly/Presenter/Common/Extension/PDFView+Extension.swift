//
//  PDFView+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/29/24.
//

import PDFKit

extension PDFView {
    func onScrollOffsetChange(handler: @escaping (UIScrollView) -> Void) -> NSKeyValueObservation? {
        detectScrollView()?.observe(\.contentOffset) { scroll, _ in
            handler(scroll)
        }
    }
    
    private func detectScrollView() -> UIScrollView? {
        for view in subviews {
            if let scroll = view as? UIScrollView {
                return scroll
            } else {
                for subview in view.subviews {
                    if let scroll = subview as? UIScrollView {
                        return scroll
                    }
                }
            }
        }
        print("Unable to find a scrollView subview on a PDFView.")
        return nil
    }
}
