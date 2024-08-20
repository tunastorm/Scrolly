//
//  BaseViewModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/20/24.
//

import Foundation

protocol ViewModelProvider {
    func transform()
}


class BaseViewModel: ViewModelProvider {
    
    private var networkProvider: APIManagerProvider
    
    deinit {
        print("deinit: ", self.self)
    }
    
    init(networkProvider: APIManagerProvider) {
        self.networkProvider = networkProvider
        transform()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transform() {
        
    }
}

