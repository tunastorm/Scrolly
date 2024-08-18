//
//  APIManager.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire
import Kingfisher
import RxSwift


// token 리프레시 후 retry 하였을 때, 최초 생성된 Single을 dispose하는 타이밍은? 현재는 dispose되지 않을 것

final class APIManager {
    
    private init() { }
    
    static let shared = APIManager()
    
    typealias APIResult = Result<Decodable, APIError>
    typealias TokenHandler = (Decodable) -> Void
    typealias RefereshHandler = (APIError) -> Void
    typealias RetryHandler = () -> Void
    
    private func callRequestAPI<T: Decodable>(model: T.Type, router: APIRouter, tokenHandler: TokenHandler? = nil, refreshHandler: RefereshHandler? = nil) -> Single<APIResult> {
        return Single.create { single in
            APIClient.request(T.self, router: router) { model in
                if let tokenHandler { tokenHandler(model) }
                single(.success(.success(model)))
            } failure: { error in
                if let refreshHandler { refreshHandler(error) }
                single(.success(.failure(error)))
            }
            return Disposables.create()
       }
    }
    
    private func callRequestRefreshToken(retryHandler: @escaping RetryHandler) {
        let router = APIRouter.refreshAccessToken
        APIClient.request(RefreshTokenModel.self, router: router) { model in
            UserDefaultsManager.token = model.accessToken
            KingfisherManager.shared.setHeaders()
            retryHandler()
        } failure: { error in
            guard error != .expiredRefreshToken else {
                print(error.message)
                return
            }
        }
    }
    
    func callRequestSignin(_ query: SigninQuery) -> Single<APIResult> {
        let router = APIRouter.signin(query)
        return callRequestAPI(model: SigninModel.self, router: router).debug("callRequestSignin")
    }
    
    func callRequestEmailValidation(_ query: EmailValidationQuery) -> Single<APIResult> {
        let router = APIRouter.emailValidation(query)
        return callRequestAPI(model: EmailValidationModel.self, router: router).debug("callRequestEmailValidation")
    }

    func callRequestLogin(_ query: LoginQuery) -> Single<APIResult> {
        let router = APIRouter.login(query)
        return callRequestAPI(model: LoginModel.self, router: router, tokenHandler: { model in
            let loginModel = model as! LoginModel
            UserDefaultsManager.token = loginModel.accessToken
            UserDefaultsManager.refresh = loginModel.refreshToken
            KingfisherManager.shared.setHeaders()
        })
        .debug("callRequestLogin")
    }

    func callRequestWithDraw() -> Single<APIResult> {
        let router = APIRouter.withdraw
        return callRequestAPI(model: WithDrawModel.self, router: router, refreshHandler: { [weak self] error in
            switch error {
            case .expiredToken:
                self?.callRequestRefreshToken() { self?.callRequestWithDraw() }
            default: break
            }
        }).debug("callRequestWithDraw")
    }
    
    func callRequestMyProfile() -> Single<APIResult> {
        let router = APIRouter.getMyProfile
        return callRequestAPI(model: MyProfileModel.self, router: router, refreshHandler: { [weak self] error in
            switch error {
            case .expiredToken:
                self?.callRequestRefreshToken() { self?.callRequestMyProfile() }
            default: break
            }
        })
        .debug("callRequestMyProfile")
    }
    
    func callRequestUpdateMyProfile(_ query: MyProfileQuery) -> Single<APIResult> {
        let router = APIRouter.updateMyProfile(query)
        return callRequestAPI(model: MyProfileModel.self, router: router, refreshHandler: { [weak self] error in
            switch error {
            case .expiredToken:
                self?.callRequestRefreshToken() { self?.callRequestUpdateMyProfile(query) }
            default: break
            }
        }).debug("callRequestUpdateMyProfile")
    }
    
    func callRequestUploadPostImage(_ query: UploadFilesQuery) -> Single<APIResult> {
        let router = APIRouter.uploadFiles(query)
        return Single.create { single in
            APIClient.upload(UploadFilesModel.self, query: query, router: router) { model in
                single(.success(.success(model)))
            } failure: { [weak self] error in
                if error == .expiredToken {
                    self?.callRequestRefreshToken {
                        print("callRequestUploadPostImage 재실행 시도")
                        self?.callRequestUploadPostImage(query)
                    }
                }
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }
        .debug("callRequestUploadPostImage")
        
//        return callRequestAPI(model: UploadFilesModel.self, router: router, refreshHandler: { [weak self] error in
//            switch error {
//            case .expiredToken:
//                self?.callRequestRefreshToken() { self?.callRequestUploadPostImage(query) }
//            default: break
//            }
//        })
        
    }
    
    
    
 
    
}
