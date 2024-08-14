//
//  APIRouter.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

enum APIRouter {
    case signin(query: SigninQuery)
    case emailValidation(query: EmailValidationQuery)
    case login(query: LoginQuery)
    case refreshAccessToken
    case withdraw
    case uploadFiles(query: UpdateFilesQuery)
    case uploadPosts(query: PostsQuery)
    case getPosts(query: GetPostsQuery)
    case queryOnePosts(id: String)
    case updatePosts(id: String, query: PostsQuery)
    case deletePosts(id: String)
    case uploadComments(id: String, query: CommentsQuery)
    case updateComments(id: String, query: CommentsQuery)
    case deleteComments(id: String)
    case likePosts(id: String, query: LikeQuery)
    case cancleLikedPosts(id: String, query: LikeQuery)
    case getLikedPosts(query: LikedPostsQuery)
    case likePostsSub(id: String, query: LikeQuery)
    case cancleLikedPostsSub(id: String, query: LikeQuery)
    case getLikedPostsSub(query: LikedPostsQuery)
    case getMyProfile
    case updateMyProfile(query: MyProfileQuery)
    case searchHashTags(query: HashTagsQuery)
    
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
                  APIConstants.contentType : APIConstants.json]
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
        case .signin, .emailValidation, .login, .uploadFiles, .uploadPosts, .uploadComments, .likePosts, .cancleLikedPosts, .likePostsSub, .cancleLikedPostsSub:
            return .post
        case .refreshAccessToken, .withdraw, .getPosts, .queryOnePosts, .getLikedPosts, .getLikedPostsSub, .getMyProfile:
            return .get
        case .updatePosts, .updateComments, .updateMyProfile, .searchHashTags:
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
        case .withdraw, .getPosts, .queryOnePosts, .deletePosts, .deleteComments, .likePosts, .cancleLikedPosts, .getLikedPosts, .likePostsSub, .cancleLikedPostsSub, .getLikedPostsSub, .getMyProfile, .searchHashTags:
            return HeadersOption.token.combineHeaders
        case .signin, .emailValidation, .login:
            return HeadersOption.json.combineHeaders
        case .uploadFiles, .updateMyProfile:
            return HeadersOption.tokenAndMulipart.combineHeaders
        case .uploadPosts, .updatePosts, .uploadComments, .updateComments:
            return HeadersOption.tokenAndJson.combineHeaders
        }
    }

    var path: String {
        return APIConstants.sesacPath(router: self)
    }
    
    var body: Data? {
        return switch self {
        case .signin(let query): encodeModel(query)
        case .emailValidation(let query): encodeModel(query)
        case .login(let query): encodeModel(query)
        case .uploadFiles(let query): encodeModel(query)
        case .uploadPosts(let query): encodeModel(query)
        case .getPosts(let query): encodeModel(query)
        case .updatePosts(let id, let query): encodeModel(query)
        case .uploadComments(let id, let query), .updateComments(let id, let query): encodeModel(query)
        case .likePosts(let id, let query), .cancleLikedPosts(let id, let query), .likePostsSub(let id, let query), .cancleLikedPostsSub(let id, let query): encodeModel(query)
        case .getLikedPosts(let query), .getLikedPostsSub(let query): encodeModel(query)
        case .updateMyProfile(let query): encodeModel(query)
        case .searchHashTags(let query): encodeModel(query)
        default: nil
        }
    }
    
    var encoder: ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
    func encodeModel(_ model: Encodable) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(model)
    }
                                                
        
}
