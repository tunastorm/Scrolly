//
//  APIClient.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//


import Foundation
import Alamofire


final class APIClient {
    
    private init() { }
    
    typealias onSuccess<T> = ((T) -> Void)
    typealias onFailure = ((_ error: APIError) -> Void)
    
    static let session = Session(interceptor: RetryInterceptor())
        
    static func request<T>(_ object: T.Type,
                           router: APIRouter,
                           success: @escaping onSuccess<T>,
                           failure: @escaping onFailure) where T:Decodable {
    
        session.request(router)
            .validate(statusCode: 200...445)
            .responseDecodable(of: object) { response in
                responseHandler(response, success: success, failure: failure)
            }
        
    }
    
    static func upload<T>(_ object: T.Type,
                          query: Encodable,
                          router: APIRouter,
                          success: @escaping onSuccess<T>,
                          failure: @escaping onFailure) where T: Decodable {
        
        session.upload(multipartFormData: { multipartFormData in
            switch router {
            case .uploadFiles: setUploadFilesForm(multipartFormData, query as! UploadFilesQuery)
            case .updateMyProfile: setUpdateMyProfileForm(multipartFormData, query as! MyProfileQuery)
            default: return
            }
        }, with: router, usingThreshold: UInt64.init())
        .validate(statusCode: 200...419)
        .responseDecodable(of: T.self ) { response in
            responseHandler(response, success: success, failure: failure)
        }
        
    }
    
    static func requestData (router: APIRouter,
                             success: @escaping (Data) -> Void,
                             failure: @escaping onFailure) {
    
        session.request(router)
            .validate(statusCode: 200...445)
            .response(responseSerializer: .data, completionHandler: { response in
                responseHandler(response, success: success, failure: failure)
            })
        
    }
    
    private static func setUploadFilesForm(_ multipartFormData: MultipartFormData, _ query: UploadFilesQuery)  {
        query.files.enumerated().forEach { idx, file in
            let mimeType = idx == 0 ? "image/jpg" : "application/pdf"
            let fileType = ".\(mimeType.split(separator: "/")[1])"
            multipartFormData.append(file, withName: "files", fileName: query.names[idx] + fileType, mimeType: mimeType)
        }
    }
    
    
    private static func setUpdateMyProfileForm(_ multipartFormData: MultipartFormData, _ query: MyProfileQuery) {
        if let nick = query.nick {
            multipartFormData.append(nick.data(using: .utf8)!, withName: "nick", mimeType: "text/plain")
        }
        if let phoneNum = query.phoneNum {
            multipartFormData.append(phoneNum.data(using: .utf8)!, withName: "phoneNum", mimeType: "text/plain")
        }
        if let birthDay = query.birthDay {
            multipartFormData.append(birthDay.data(using: .utf8)!, withName: "birthDay", mimeType: "text/plain")
        }
        if let image = query.profile {
            multipartFormData.append(image, withName: "profile", fileName: "\(query.nick ?? "profile").jpg", mimeType: "image/jpg")
        }
        
    }
    
    private static func responseHandler<T: Decodable>(_ response: AFDataResponse<T>, success: @escaping (T) -> Void, failure: @escaping onFailure) {
        if let error = responseErrorHandler(response) {
            return failure(error)
        }
        switch response.result  {
        case .success(let result):
            success(result)
        case .failure(let AFError):
            let error = convertAFErrorToAPIError(AFError)
            failure(error)
        }
    }
    
    private static func responseErrorHandler<T: Decodable>(_ response: AFDataResponse<T>) -> APIError? {
        if let statusCode = response.response?.statusCode, let statusError = convertResponseStatus(statusCode) {
            print("statusCode: ", statusCode)
            return statusError
        }
        guard let decodedData = response.value else {
            return .noResponseData
        }
        return nil
    }
    
    private static func convertResponseStatus(_ statusCode: Int) -> APIError? {
        return switch statusCode {
        case 200: nil
        case 400: .invalidRequest
        case 401: .invalidToken
        case 402: .invalidNick
        case 403: .accessForbidden
        case 409: .validationFaild
        case 410: .taskFailed
        case 418: .expiredRefreshToken
        case 419: .expiredToken
        case 420: .invalidKey
        case 429: .tooManyRequest
        case 444: .invalidURL
        case 445: .unAuthorizedRequest
        case 300 ..< 400: .redirectError
        case 402 ..< 500: .clientError
        case 500 ..< 600: .serverError
        default: .networkError
        }
    }
    
    private static func convertAFErrorToAPIError(_ error: AFError) -> APIError {
        return switch error {
        case .createUploadableFailed: .failedRequest
        case .createURLRequestFailed: .clientError
        case .downloadedFileMoveFailed: .invalidData
        case .explicitlyCancelled: .canceled
        case .invalidURL: .clientError
        case .multipartEncodingFailed: .failedRequest
        case .parameterEncodingFailed: .failedRequest
        case .parameterEncoderFailed:  .failedRequest
        case .requestAdaptationFailed:  .failedRequest
        case .requestRetryFailed: .failedRequest
        case .responseValidationFailed: .invalidResponse
        case .responseSerializationFailed: .invalidData
        case .serverTrustEvaluationFailed: .networkError
        case .sessionDeinitialized: .invalidSession
        case .sessionInvalidated: .invalidSession
        case .sessionTaskFailed: .networkError
        case .urlRequestValidationFailed: .clientError
        }
    }

}


