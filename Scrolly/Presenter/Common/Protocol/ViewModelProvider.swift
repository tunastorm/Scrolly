//
//  ViewModelProvider.swift
//  Scrolly
//
//  Created by 유철원 on 8/26/24.
//

import UIKit

protocol ViewModelProvider {
    associatedtype Input
    associatedtype Output
    
    var model: PostsModel? { get set }
    
    func transform(input: Input) -> Output?
    
}
