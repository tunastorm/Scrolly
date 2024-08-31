//
//  UpdateFilesQuery.swift
//  Scrolly
//
//  Created by 유철원 on 8/14/24.
//

import Foundation
import Alamofire

struct UploadFilesQuery: Encodable {
    
    let names: [String]
    let types: [String]
    let files: [Data]
    
}
