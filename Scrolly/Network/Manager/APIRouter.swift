//
//  APIRouter.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

enum APIRouter {
    case signin(email: String, password:String, nick: String, phoneNum: String? = nil, birthDay: String? = nil)
    case emailValidation
    case login
    case refreshAccessToken
    case withdraw
    case uploadFiles
    case uploadPosts
    case getPosts
    case queryOnePosts
    case updatePosts
    case deletePosts
    case uploadComments
    case updateComments
    case deleteComments
    case likePosts
    case cancleLikedPosts
    case getLikedPosts
    case likePostsSub
    case cancleLikedPostsSub
    case getLikedPostsSub
    case getMyProfile
    case updateMyProfile
    case searchHashTags
    
}

//extension APIRouter: TargetType {
// 
//    // 열거형 asoociate value
//    var baseURL: String {
//        return APIConstants.baseURL
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .signin, .emailValidation, .login, .uploadFiles, .uploadPosts, .uploadComments, .likePosts, .cancleLikedPosts, .likePostsSub, .cancleLikedPostsSub:
//            return .post
//        case .refreshAccessToken, .withdraw, .getPosts, .queryOnePosts, .getLikedPosts, .getLikedPostsSub, .getMyProfile:
//            return .get
//        case .updatePosts, .updateComments, .updateMyProfile, .searchHashTags:
//            return .put
//        case .deletePosts, .deleteComments:
//            return .delete
//        }
//    }
//    
//    var headers: HTTPHeaders {
//        [
//          APIConstants.sesacKey : APIKey.sesacKey,
//          APIConstants.authorization : UserDefaultsManager.token
//        ]
//    }
//
//    var path: String {
//        return switch self {
//        case .signin(let email, let password, let nick, let phoneNum, let birthDay):
//        case .emailValidation:
//        case .login:
//        case .refreshAccessToken:
//        case .withdraw:
//        case .uploadFiles:
//        case .uploadPosts:
//        case .getPosts:
//        case .queryOnePosts:
//        case .updatePosts:
//        case .deletePosts:
//        case .uploadComments:
//        case .updateComments:
//        case .deleteComments:
//        case .likePosts:
//        case .cancleLikedPosts:
//        case .getLikedPosts:
//        case .likePostsSub:
//        case .cancleLikedPostsSub:
//        case .getLikedPostsSub:
//        case .getMyProfile:
//        case .updateMyProfile:
//        case .searchHashTags:
//        }
//    }
//    
//    var parameters: Encodable? {
//        return switch self {
//        case .searchPhotos(let query): query
//        case .topicPhotos(let query): query
//        case .randomPhoto: nil
//        case .photoStatistics(let query): query
//        }
//    }
//    
//    var encoder: ParameterEncoder {
//        switch self {
//        case .topicPhotos, .searchPhotos, .randomPhoto, .photoStatistics:
//            return URLEncodedFormParameterEncoder.default
//        }
//    }
//    
//    enum Sorting: Int, CaseIterable {
//        case relevant = 0
//        case latest
//      
//        
//        var name: String {
//            return switch self {
//            case .relevant: "relevant"
//            case .latest: "latest"
//            }
//        }
//        
//        var krName: String {
//            return switch self {
//            case .relevant: "관련순"
//            case .latest: "최신순"
//            }
//        }
//    }
//    
//    private func makePath() {
//        
//    }
//}
