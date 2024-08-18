//
//  APIError.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation

enum APIError: Error {
    case canceled
    case failedRequest
    case noResponseData
    case invalidResponse
    case invalidSession
    case invalidRequest
    case invalidToken
    case accessForbidden
    case expiredRefreshToken
    case expiredToken
    case validationFaild
    case taskFailed
    case unAuthorizedRequest
    case networkError
    case redirectError
    case clientError
    case serverError
    case invalidData
    case noResultError
    case unExpectedError
    
//    var title: String {
//        return switch self {
//        case .canceled: "[ 세션 요청 취소 ]"
//        case .failedRequest: "[ 세션 요청 실패 ]"
//        case .noData: "[ 응답 데이터 없음 ]"
//        case .invalidResponse: "[ 응답 유효성 에러 ]"
//        case .invalidSession: "[ 세션 인증 실패 ]"
//        case .invalidRequest: "[ 요청 양식 에러 ]"
//        case .invalidToken: "[ 토큰 인증 에러 ]"
//        case .accessForbidden: "[ 접근 권한 없음 ]"
//        case .expiredToken: "[ 토큰 만료 ]"
//        case .validationFaild: "[ 유효성 검증 실패 ]"
//        case .taskFailed: "[ 요청 작업 실패 ]"
//        case .unAuthorizedRequest: "[ 권한 없는 요청 ]"
//        case .networkError: "[ 네트워크 에러 ]"
//        case .redirectError: "[ 리소스 경로 변경 ]"
//        case .clientError: "[ 잘못된 요청 ]"
//        case .serverError: "[ 서비스 상태 불량 ]"
//        case .invalidData: "[ 데이터 유효성 에러 ]"
//        case .noResultError: "[ 검색 결과 없음 ]"
//        case .unExpㅋㄴectedError: "[ 비정상적인 에러 ]"
//        }
//    }
    
    var message: String {
        return switch self {
        case .canceled: "요청이 취소되었습니다."
        case .failedRequest: "데이터 요청에 실패하였습니다.\n 네트워크 환경을 확인하세요."
        case .noResponseData: "응답 데이터가 존재하지 않습니다."
        case .invalidResponse: "유효하지 않은 응답입니다."
        case .invalidSession: "세션의 정보가 유효하지 않습니다. 다시 로그인해 주세요."
        case .invalidRequest: "잘못된 요청입니다"
        case .invalidToken: "인증할 수 없는 엑세스 토큰입니다."
        case .accessForbidden: "접근 권한이 없는 요청입니다."
        case .expiredRefreshToken: "리프레시 토큰이 만료되었습니다. 다시 로그인 해주세요."
        case .expiredToken: "엑세스 토큰이 만료되었습니다."
        case .validationFaild: "사용이 불가한 이메일입니다."
        case .taskFailed: " 찾을 수 없습니다" // 댓글 생성 실패시 분기처리 필요
        case .unAuthorizedRequest: " 권한이 없습니다" // 요청 API종류에 따른 분기처리 필요
        case .networkError: "네트워크 연결상태를 확인하세요."
        case .redirectError: "요청한 리소스의 주소가 변경되었습니다.\n  올바른 주소로 다시 요청해주세요."
        case .clientError: "잘못된 요청이거나 접근권한이 없습니다."
        case .serverError: "일시적인 서비스 장애입니다.\n  잠시 후 다시 시도해주세요."
        case .invalidData: "응답 데이터가 유효하지 않습니다."
        case .noResultError: "검색어에 해당하는 결과가 없습니다."
        case .unExpectedError: "알 수 없는 에러가 발생하였습니다.\n 고객센터로 문의하세요."
        }
    }
    
    
    
    
}
