//
//  PaymentStatus.swift
//  Scrolly
//
//  Created by 유철원 on 8/30/24.
//

import Foundation


enum PaymentStatus {
    static let AlertMessage = "유료 회차입니다.\n100원 결제를 진행하시겠습니까?"
    static let AlertTitle = "결제하기"
    static let Failed = "결제에 실패하였습니다.\n이전 화면으로 돌아갑니다."
    static let Success = "결제 성공, 뒤로 돌아가 감상을 시작하세요."
    static let Cancle = "결제를 취소합니다"
}
