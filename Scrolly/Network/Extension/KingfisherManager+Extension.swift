//
//  Kingfisher+Extension.swift
//  Scrolly
//
//  Created by 유철원 on 8/18/24.
//

import Foundation
import Kingfisher

extension KingfisherManager {
    
    func setHeaders() {
        let modifier = AnyModifier { request in
            var req = request
            req.addValue(UserDefaultsManager.token, forHTTPHeaderField: APIConstants.authorization)
            req.addValue(APIKey.sesacKey, forHTTPHeaderField: APIConstants.sesacKey)
            return req
        }

        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier)
        ]
    }
    
}
