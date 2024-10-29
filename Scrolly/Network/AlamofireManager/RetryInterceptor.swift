//
//  NetworkInterceptor.swift
//  Scrolly
//
//  Created by 유철원 on 8/19/24.
//

import Foundation
import Alamofire

final class RetryInterceptor: RetryPolicy {
    
//    private let retryLimitation = 1
    private let retryDelay: TimeInterval = 1
    
    
    override func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 가능한 상태코드:", retryableHTTPStatusCodes)
        print("retry 가능한 URLErrorCodes:", retryableURLErrorCodes)
        print(#function, "리트라이 로직 스타트")
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetry)
            print(#function, "리트라이 안함")
            return
        }
        
        getToken { isSuccess, error in
            print(#function, "리트라이 isSuccess: \(isSuccess)")
            if isSuccess {
                if request.retryCount < Self.defaultRetryLimit {
                    completion(.retryWithDelay(self.retryDelay))
                } else {
                    print("리트라이 회수 초과")
                }
                return
            }
            if let error {
                NotificationCenter.default.post(name: NSNotification.Name(RefreshTokenNotification.expired), object: nil, userInfo: nil)
            }
            print("결국 리트라이 안함")
            completion(.doNotRetry)
        }
    }

    private func getToken(completion: @escaping(Bool,APIError?) -> Void) {
        APIManager.shared.callRequestRefreshToken() { result in
            switch result {
            case .success(let model): 
                print(#function, "갱신성공")
                return completion(true, nil)
            case .failure(let error):
                print(#function, "갱신실패")
                return completion(false, error)
            }
        }
    }

}
