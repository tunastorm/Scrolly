//
//  APIRouter.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

enum APIRouter {
    case signin(_ query: SigninQuery)
    case emailValidation(_ query: EmailValidationQuery)
    case login(_ query: LoginQuery)
    case refreshAccessToken
    case withdraw
    case uploadFiles(_ query: UploadFilesQuery)
    case uploadPosts(_ query: PostsQuery)
    case getPosts(_ query: GetPostsQuery)
    case getPostsImage(file: String)
    case queryOnePosts(id: String)
    case updatePosts(id: String, _ query: PostsQuery)
    case deletePosts(id: String)
    case uploadComments(id: String, _ query: CommentsQuery)
    case updateComments(id: String, _ query: CommentsQuery)
    case deleteComments(id: String)
    case likePosts(id: String, _ query: LikeQuery)
    case cancleLikedPosts(id: String, _ query: LikeQuery)
    case getLikedPosts(_ query: LikedPostsQuery)
    case likePostsSub(id: String, _ query: LikeQuery)
    case cancleLikedPostsSub(id: String, _ query: LikeQuery)
    case getLikedPostsSub(_ query: LikedPostsQuery)
    case getMyProfile
    case updateMyProfile(_ query: MyProfileQuery)
    case searchHashTags(_ query: HashTagsQuery)
}

extension APIRouter: TargetType {
   
    enum HeadersOption {
        case json
        case token
        case tokenAndRefresh
        case tokenAndMulipart
        case tokenAndJson
        case tokenAndProductId
        case tokenJsonProductId
        
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
            case .tokenAndProductId:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.productId : "" ]
            case .tokenJsonProductId:
                [ APIConstants.authorization : UserDefaultsManager.token,
                  APIConstants.contentType : APIConstants.json,
                  APIConstants.productId : "" ]
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
        case .refreshAccessToken, .withdraw, .getPosts, .getPostsImage, .queryOnePosts, .getLikedPosts, .getLikedPostsSub, .getMyProfile:
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
        case .uploadPosts(let query):
            var headers = HeadersOption.tokenJsonProductId.combineHeaders
            headers[APIConstants.productId] = query.productId
            return headers
        case .getPosts(let query):
            var headers = HeadersOption.tokenAndProductId.combineHeaders
            headers[APIConstants.productId] = query.productId
            return headers
        case .withdraw, .getPostsImage, .queryOnePosts, .deletePosts, .deleteComments, .likePosts, .cancleLikedPosts, .getLikedPosts, .likePostsSub, .cancleLikedPostsSub, .getLikedPostsSub, .getMyProfile, .searchHashTags:
            return HeadersOption.token.combineHeaders
        case .signin, .emailValidation, .login:
            return HeadersOption.json.combineHeaders
        case .uploadFiles, .updateMyProfile:
            return HeadersOption.tokenAndMulipart.combineHeaders
        case .updatePosts, .uploadComments, .updateComments:
            return HeadersOption.tokenAndJson.combineHeaders
        }
    }

    var path: String {
        return APIConstants.sesacPath(router: self)
    }
    
    var body: Data? {
        return switch self {
        case .signin(let query): encodeQuery(query)
        case .emailValidation(let query): encodeQuery(query)
        case .login(let query): encodeQuery(query)
        case .getPosts(let query): encodeQuery(query)
        case .updatePosts(let id, let query): encodeQuery(query)
        case .uploadComments(let id, let query), .updateComments(let id, let query): encodeQuery(query)
        case .likePosts(let id, let query), .cancleLikedPosts(let id, let query), .likePostsSub(let id, let query), .cancleLikedPostsSub(let id, let query): encodeQuery(query)
        case .getLikedPosts(let query), .getLikedPostsSub(let query): encodeQuery(query)
        case .updateMyProfile(let query): encodeQuery(query)
        case .searchHashTags(let query): encodeQuery(query)
        default: nil
        }
    }
    
    var encoder: ParameterEncoder {
        return URLEncodedFormParameterEncoder.default
    }
    
    private func encodeQuery(_ query: Encodable) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(query)
    }
    
}
