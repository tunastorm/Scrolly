//
//  UploadFilesModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/17/24.
//

import Foundation

struct UploadFilesModel: Decodable {
    let files: [String]
    let message: String?
}
