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
//        AF.request(router)
//            .responseString { response in
//                print(#function)
//                dump(response.result)
//            }
//        
        session.request(router)
            .validate(statusCode: 200...445)
            .responseDecodable(of: object) { response in
                if let error = responseErrorHandler(response) {
                    return failure(error)
                }
                switch response.result {
                case .success(let result):
                    success(result)
                case .failure(let AFError):
                    let error = convertAFErrorToAPIError(AFError)
                    failure(error)
                }
            }
        
        
        
    }
    
    static func upload<T>(_ object: T.Type,
                          query: UploadFilesQuery,
                          router: APIRouter,
                          success: @escaping onSuccess<T>,
                          failure: @escaping onFailure) where T: Decodable {
        
        session.upload(multipartFormData: { multipartFormData in
            query.files.enumerated().forEach { idx, file in
                let mimeType = idx == 0 ? "image/jpg" : "application/pdf"
                let fileType = ".\(mimeType.split(separator: "/")[1])"
                multipartFormData.append(file, withName: "files", fileName: query.names[idx] + fileType, mimeType: mimeType)
            }
        }, with: router, usingThreshold: UInt64.init())
        .validate(statusCode: 200...419)
        .responseDecodable(of: T.self ){ response in
            if let error = responseErrorHandler(response) {
                return failure(error)
            }
            switch response.result {
            case .success(let result):
                success(result)
            case .failure(let AFError):
                let error = convertAFErrorToAPIError(AFError)
                failure(error)
            }
        }
        .uploadProgress { progress in
            
        }
    }
    
    private static func responseErrorHandler<T: Decodable>(_ response: AFDataResponse<T>) -> APIError? {
        if let statusCode = response.response?.statusCode, let statusError = convertResponseStatus(statusCode){
            return statusError
        }
        dump(response.result)
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
        case 403: .accessForbidden
        case 409: .validationFaild
        case 410: .taskFailed
        case 418: .expiredRefreshToken
        case 419: .expiredToken
//        case 420:
//        case 429:
//        case 444:
//        case 500:
        case 445: .unAuthorizedRequest
        case 300 ..< 400: .redirectError
        case 402 ..< 500: .clientError
        case 501 ..< 600: .serverError
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


