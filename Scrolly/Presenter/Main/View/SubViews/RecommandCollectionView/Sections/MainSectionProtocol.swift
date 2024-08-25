//
//  MainSectionProtocol.swift
//  Scrolly
//
//  Created by 유철원 on 8/25/24.
//

import Foundation

protocol MainSection: CaseIterable, Hashable {
    var value: String { get }
    var header: String? { get }
}
