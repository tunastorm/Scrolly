//
//  UIScrollView+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit

extension UIScrollView {
    
    /// 스크롤 방향
    enum ScrollDirection {
        case previous
        case next
        case flink // 스크린에서 터치가 끝난 이후에 스크롤이 진행될때,
                   //(0,0) 상태를 처리하기 위한 case
    }
    
    /// 스크롤 뷰 축 방향
    enum ScrollAxis {
        case horizontal
        case vertical
    }
    
    /// 스크롤뷰의 스크롤 되는 방향.
    /// - velocity를 사용하여 스크롤뷰의 스크롤 방향을 계산
    var scrollDirection: ScrollDirection {
        
        let velocity = self.panGestureRecognizer.velocity(in: self)
        // 스크롤 뷰의 컨텐츠 높이와 폭의 길이를 비교하여 스크롤뷰의 축 방향을 정한다.
        let scrollAxis = self.contentSize.height > self.contentSize.width ? ScrollAxis.vertical : ScrollAxis.horizontal
        switch scrollAxis {
        case .horizontal:
            guard velocity.x >= 0 else {
                return .next
            }
            guard velocity.x == 0 else {
                return .previous
            }
            return .flink
        case .vertical:
            guard velocity.y >= 0 else {
                return .next
            }
            guard velocity.y == 0 else {
                return .previous
            }
            return .flink
        }
    }
}
