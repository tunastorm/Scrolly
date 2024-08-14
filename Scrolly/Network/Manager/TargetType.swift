//
//  TargetType.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var body: Data? { get }
    var encoder: ParameterEncoder { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try (baseURL + path).asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)
        if let body {
            print(#function, "body: ", body)
            request.httpBody = body
        }
        return request
    }
    
}
