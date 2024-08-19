//
//  NetworkInterceptor.swift
//  Scrolly
//
//  Created by 유철원 on 8/19/24.
//

import Foundation
import Alamofire

final class RetryInterceptor: RetryPolicy {
    
    private let retryLimitation = 3
    private let retryDelay: TimeInterval = 1
    
    override func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetry)
            return
        }
        
        getToken { isSuccess, error in
            if isSuccess {
                if request.retryCount < self.retryLimit {
                    completion(.retryWithDelay(self.retryDelay))
                }
                return
            }
            if let error { print(error) }
            // NotificationCentor를 이용해 login 화면으로 이동
            completion(.doNotRetry)
        }
    }

    private func getToken(completion: @escaping(Bool,APIError?) -> Void) {
        APIManager.shared.callRequestRefreshToken() { result in
            switch result {
            case .success(let model): completion(true, nil)
            case .failure(let error): completion(false, error)
            }
        }
    }

}
