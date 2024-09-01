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
    
    override func configNavigationbar(backgroundColor: UIColor = .clear, backButton: Bool = true, shadowImage: Bool = false, foregroundColor: UIColor = .black, barbuttonColor: UIColor = .black, showProfileButton: Bool = true, titlePosition: TitlePosition = .center) {
        super.configNavigationbar(backgroundColor: Resource.Asset.CIColor.white, foregroundColor: Resource.Asset.CIColor.white, showProfileButton: false)
        navigationItem.title = "결제하기"
    }
    
    
    private func showPaymentPage() {
        guard let webView = rootView?.wkWebView, let price = model?.price, let complitionHandler else {
            return
        }
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: APIKey.pgId),
            merchant_uid: APIKey.merchantUid + String(Int(Date().timeIntervalSince1970)),
            amount: String(price)).then {
        $0.pay_method = PayMethod.card.rawValue
        $0.name = APIKey.companyName
        $0.buyer_name = APIKey.paymentTester
        $0.app_scheme = APIKey.appScheme
        }
        
        Iamport.shared.paymentWebView(
            webViewMode: webView,
            userCode: APIKey.iamportCode,
            payment: payment) { [weak self] iamportResponse in
                dump(iamportResponse)
                switch iamportResponse?.success {
                case true:
                    guard let uid = iamportResponse?.imp_uid else {
                        return
                    }
                    self?.callValidation(uid, complitionHandler: complitionHandler)
                case false:
//                    self?.rootView?.makeToast(PaymentStatus.Cancle)
                    self?.popBeforeView(animated: true)
                default: break
                }
            }
    }
    
    private func callValidation(_ uid: String, complitionHandler: @escaping () -> Void) {
        guard let postId = model?.postId, let model else {
//            self.rootView?.makeToast(PaymentStatus.Failed)
            popBeforeView(animated: true)
            return
        }
        let query = PaymentValidationQuery(impUid: uid, postId: postId)
        APIClient.request(PaymentModel.self, router: .paymentValidation(query)) { [weak self] result in
//            self?.rootView?.makeToast(PaymentStatus.Success)
            complitionHandler()
        } failure: { [weak self] error in
//            self?.rootView?.makeToast(PaymentStatus.Failed)
            self?.popBeforeView(animated: true)
        }
    }
    
}
