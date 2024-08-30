//
//  PaymentViewController.swift
//  Scrolly
//
//  Created by 유철원 on 8/30/24.
//

import UIKit
import iamport_ios
import RxSwift
import RxCocoa

final class PaymentViewController: BaseViewController<PaymentView> {
    
    var model: PostsModel?
    
    var complitionHandler: (() -> Void)?
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        showPaymentPage()
    }
    
    private func showPaymentPage() {
        guard let webView = rootView?.wkWebView, let price = model?.price, let complitionHandler else {
            return
        }
        
        let payment = IamportPayment(
                pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                amount: String(price)).then {
        $0.pay_method = PayMethod.card.rawValue
        $0.name = " "
        $0.buyer_name = " "
        $0.app_scheme = "sesac"
        }
        
        Iamport.shared.paymentWebView(
            webViewMode: webView,
            userCode: APIKey.iamportCode,
            payment: payment) { [weak self] iamportResponse in
                dump(iamportResponse)
                switch iamportResponse?.success {
                case true:
                    print(#function, "포트원 결제 성공", iamportResponse?.imp_uid)
                    guard let uid = iamportResponse?.imp_uid else {
                        return
                    }
                    self?.callValidation(uid, complitionHandler: complitionHandler)
                case false:
                    self?.rootView?.makeToast("결제를 취소합니다")
                    self?.popBeforeView(animated: true)
                default: break
                }
            }
    }
    
    private func callValidation(_ uid: String, complitionHandler: @escaping () -> Void) {
        guard let postId = model?.postId, let model else {
            self.rootView?.makeToast("결제에 실패하였습니다. 원래화면으로 돌아갑니다.")
            popBeforeView(animated: true)
            return
        }
        let query = PaymentValidationQuery(impUid: uid, postId: postId)
        APIClient.request(PaymentModel.self, router: .paymentValidation(query)) { [weak self] result in
            print(#function, "결제 최종 성공")
            complitionHandler()
        } failure: { [weak self] error in
            self?.rootView?.makeToast("결제에 실패하였습니다. 원래화면으로 돌아갑니다.")
            self?.popBeforeView(animated: true)
        }
    }
    
}
