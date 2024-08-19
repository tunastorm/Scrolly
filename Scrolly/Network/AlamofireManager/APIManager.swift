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
    
    typealias CallResult = Single<APIResult>
    typealias APIResult = Result<Decodable, APIError>
    typealias TokenHandler = (Decodable) -> Void
    typealias RefreshHandler = (APIError) -> Observable<APIResult>?
    typealias RetryHandler = () -> Observable<APIResult>?
    
    private let disposeBag = DisposeBag()
    
    private func callRequestAPI<T: Decodable>(model: T.Type, router: APIRouter, tokenHandler: TokenHandler? = nil) -> CallResult {
        return Single.create { single in
            APIClient.request(T.self, router: router) { model in
                if let tokenHandler { tokenHandler(model) }
                single(.success(.success(model)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
       }
    }

    
    func callRequestRefreshToken(completion: @escaping (APIResult) -> Void) {
        let router = APIRouter.refreshAccessToken
        APIClient.request(RefreshTokenModel.self, router: router) { model in
            UserDefaultsManager.token = model.accessToken
            KingfisherManager.shared.setHeaders()
            completion(.success(model))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    
    func callRequestSignin(_ query: SigninQuery) -> CallResult {
        let router = APIRouter.signin(query)
        return callRequestAPI(model: SigninModel.self, router: router).debug(#function.description)
    }
    
    func callRequestEmailValidation(_ query: EmailValidationQuery) -> CallResult {
        let router = APIRouter.emailValidation(query)
        return callRequestAPI(model: EmailValidationModel.self, router: router).debug(#function.description)
    }

    func callRequestLogin(_ query: LoginQuery) -> CallResult {
        let router = APIRouter.login(query)
        return callRequestAPI(model: LoginModel.self, router: router, tokenHandler: { model in
            let loginModel = model as! LoginModel
            UserDefaultsManager.token = loginModel.accessToken
            UserDefaultsManager.refresh = loginModel.refreshToken
            KingfisherManager.shared.setHeaders()
        })
        .debug(#function.description)
    }

    func callRequestWithDraw() -> CallResult {
        let router = APIRouter.withdraw
        return callRequestAPI(model: WithDrawModel.self, router: router).debug(#function.description)
    }
    
    func callRequestMyProfile() -> CallResult {
        let router = APIRouter.getMyProfile
        return callRequestAPI(model: MyProfileModel.self, router: router).debug(#function.description)
    }
    
    func callRequestUpdateMyProfile(_ query: MyProfileQuery) -> CallResult {
        let router = APIRouter.updateMyProfile(query)
        return callRequestAPI(model: MyProfileModel.self, router: router).debug(#function.description)
    }
    
    func callRequestUploadPostImage(_ query: UploadFilesQuery) -> Single<APIResult> {
        print(#function, "업로드 이미지")
        let router = APIRouter.uploadFiles(query)
        return Single.create { single in
            APIClient.upload(UploadFilesModel.self, query: query, router: router) { model in
                single(.success(.success(model)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }.debug(#function.description)
    }
    
}
