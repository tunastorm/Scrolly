//
//  BaseViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import Foundation


class BaseViewModel {
    
    deinit {
        print("deinit: ", self.self)
    }
    
    init() { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

