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


protocol APIManagerProvider {
    
    typealias ModelResult<T> = Result<T, APIError>
    typealias DataResult = Result<Data, APIError>
    typealias TokenHandler = (Decodable) -> Void
    
    func callRequestAPI<T: Decodable>(model: T.Type, router: APIRouter, tokenHandler: TokenHandler?) -> Single<ModelResult<T>>
    func callRequestRefreshToken(completion: @escaping (ModelResult<RefreshTokenModel>) -> Void)
    func callRequestUploadFiles<T: Decodable>(model: T.Type, _ router: APIRouter, _ query: Encodable) -> Single<ModelResult<T>>
    func callRequestData(_ router: APIRouter) -> Single<DataResult>
    
}


final class APIManager: APIManagerProvider {
  
    private init() { }
    
    static let shared = APIManager()
    
    typealias ModelResult<T:Decodable> = Result<T, APIError>
    typealias DataResult = Result<Data, APIError>
    typealias TokenHandler = (Decodable) -> Void
    
    func callRequestAPI<T: Decodable>(model: T.Type, router: APIRouter, tokenHandler: TokenHandler? = nil) -> Single<ModelResult<T>> {
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
    
    func callRequestRefreshToken(completion: @escaping (ModelResult<RefreshTokenModel>) -> Void) {
        let router = APIRouter.refreshAccessToken
        APIClient.request(RefreshTokenModel.self, router: router) { model in
            UserDefaultsManager.token = model.accessToken
            KingfisherManager.shared.setHeaders()
            completion(.success(model))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    func callRequestUploadFiles<T: Decodable>(model: T.Type, _ router: APIRouter, _ query: Encodable) -> Single<ModelResult<T>> {
        return Single.create { single in
            APIClient.upload(T.self, query: query, router: router) { model in
                single(.success(.success(model)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }.debug(router.description)
    }
    
    func callRequestData(_ router: APIRouter) -> Single<DataResult> {
        return Single.create { single in
            APIClient.requestData(router: router) { data in
                single(.success(.success(data)))
            } failure: { error in
                single(.success(.failure(error)))
            }
            return Disposables.create()
        }.debug(router.description)

    }
    
    func callRequestLogin(_ router: APIRouter) -> Single<ModelResult<LoginModel>> {
        return callRequestAPI(model: LoginModel.self, router: router, tokenHandler: { model in
            let loginModel = model as! LoginModel
            UserDefaultsManager.token = loginModel.accessToken
            UserDefaultsManager.refresh = loginModel.refreshToken
            UserDefaultsManager.nick = loginModel.nick
            UserDefaultsManager.user = loginModel.email
            UserDefaultsManager.profile = loginModel.profileImage ?? "default"
            KingfisherManager.shared.setHeaders()
        })
        .debug(router.description)
    }
  
}
