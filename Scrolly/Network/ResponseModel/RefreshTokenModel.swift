//
//  RefreshTokenModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation


struct RefreshTokenModel: Decodable {
    let accessToken: String
    let message: String?
}
