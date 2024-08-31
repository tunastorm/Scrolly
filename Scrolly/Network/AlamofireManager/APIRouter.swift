//
//  APIRouter.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

enum APIRouter {
    case signUp(_ query: SignUpQuery)
    case emailValidation(_ query: EmailValidationQuery)
    case login(_ query: LoginQuery)
    case refreshAccessToken
    case withdraw
    case uploadFiles(_ query: UploadFilesQuery)
    case uploadPosts(_ query: PostsQuery)
    case getPosts(_ query: GetPostsQuery)
    case getPostsImage(_ file: String)
    case queryOnePosts(_ id: String)
    case updatePosts(_ id: String, _ query: PostsQuery)
    case deletePosts(_ id: String)
    case uploadComments(_ id: String, _ query: CommentsQuery)
    case updateComments(_ id: String, _ commentId: String, _ query: CommentsQuery)
    case deleteComments(_ id: String, _ commentId: String)
    case likePostsToggle(_ id: String, _ query: LikeQuery)
    case getLikedPosts(_ query: LikedPostsQuery)
    case likePostsToggleSub(_ id: String, _ query: LikeQuery)
    case getLikedPostsSub(_ query: LikedPostsQuery)
    case getMyProfile
    case updateMyProfile(_ query: MyProfileQuery)
    case searchHashTags(_ query: HashTagsQuery)
    case paymentValidation(_ query: PaymentValidationQuery)
    case paymentedList
}

extension APIRouter: TargetType {
   
    enum HeadersOption {
        case json
        case token
        case tokenAndRefresh
        case tokenAndMulipart
        case tokenAndJson
        
        var headers: [String: String] {
            return switch self {
            case .json:
                [ APIConstants.contentType : APIConstants.json ]
            case .token:
                [ APIConstants.authorization : UserDefaultsManager.token ]
            case .tokenAndRefresh:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.refresh : UserDefaultsManager.refresh ]
            case .tokenAndMulipart:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.contentType : APIConstants.multipart ]
            case .tokenAndJson:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.contentType : APIConstants.json ]
            }
        }
        
        var combineHeaders: HTTPHeaders {
            let values = self.headers
            var headers  = APIRouter.baseHeaders
            values.forEach { key, value in
                headers.add(name: key, value: value)
            }
            return headers
        }
    
    }
    
    // 열거형 asoociate value
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp, .emailValidation, .login, .uploadFiles, .uploadPosts, .uploadComments, .likePostsToggle, .likePostsToggleSub, .paymentValidation:
            return .post
        case .refreshAccessToken, .withdraw, .getPosts, .getPostsImage, .queryOnePosts, .getLikedPosts, .getLikedPostsSub, .getMyProfile, .searchHashTags, .paymentedList:
            return .get
        case .updatePosts, .updateComments, .updateMyProfile:
            return .put
        case .deletePosts, .deleteComments:
            return .delete
        }
    }
    
    static var baseHeaders: HTTPHeaders {
        [ APIConstants.sesacKey : APIKey.sesacKey ]
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .refreshAccessToken:
            return HeadersOption.tokenAndRefresh.combineHeaders
        case .withdraw, .getPosts, .getPostsImage, .queryOnePosts, .deletePosts, .deleteComments, .getLikedPosts, .getLikedPostsSub, .getMyProfile, .searchHashTags:
            return HeadersOption.token.combineHeaders
        case .signUp, .emailValidation, .login:
            return HeadersOption.json.combineHeaders
        case .uploadFiles, .updateMyProfile:
            return HeadersOption.tokenAndMulipart.combineHeaders
        case .uploadPosts, .updatePosts, .uploadComments, .updateComments, .likePostsToggle, .likePostsToggleSub, .paymentValidation, .paymentedList:
            return HeadersOption.tokenAndJson.combineHeaders
        }
    }

    var path: String {
        return APIConstants.sesacPath(router: self)
    }
    
    var body: Data? {
        return switch self {
        case .signUp(let query): 
            encodeQuery(query)
        case .emailValidation(let query): 
            encodeQuery(query)
        case .login(let query): 
            encodeQuery(query)
        case .uploadPosts(let query): 
            encodeQuery(query)
        case .updatePosts(let id, let query): 
            encodeQuery(query)
        case .uploadComments(let id, let query):
            encodeQuery(query)
        case .updateComments(let id, let commentId, let query):
            encodeQuery(query)
        case .likePostsToggle(let id, let query), .likePostsToggleSub(let id, let query):
            encodeQuery(query)
        case .paymentValidation(let query):
            encodeQuery(query)
        default: nil
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .getPosts(let query): query
        case .getLikedPosts(let query), .getLikedPostsSub(let query): query
        case .searchHashTags(let query): query
        default: nil
        }
    }
    
    var encoder: ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
    var description: String {
        switch self {
        case .signUp: "signin"
        case .emailValidation: "emailValidation"
        case .login: "login"
        case .refreshAccessToken: "refreshAccessToken"
        case .withdraw: "withdraw"
        case .uploadFiles: "uploadFiles"
        case .uploadPosts: "uploadPosts"
        case .getPosts: "getPosts"
        case .getPostsImage: "getPostsImage"
        case .queryOnePosts: "queryOnePosts"
        case .updatePosts: "updatePosts"
        case .deletePosts: "deletePosts"
        case .uploadComments: "uploadComments"
        case .updateComments: "updateComments"
        case .deleteComments: "deleteComments"
        case .likePostsToggle: "likePostsToggle"
        case .getLikedPosts: "getLikedPosts"
        case .likePostsToggleSub: "likePostsToggleSub"
        case .getLikedPostsSub: "getLikedPostsSub"
        case .getMyProfile: "getMyProfile"
        case .updateMyProfile: "updateMyProfile"
        case .searchHashTags: "searchHashTags"
        case .paymentValidation: "paymentValidation"
        case .paymentedList: "paymentList"
        }
    }
    
    private func encodeQuery(_ query: Encodable) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(query)
    }
    
}
