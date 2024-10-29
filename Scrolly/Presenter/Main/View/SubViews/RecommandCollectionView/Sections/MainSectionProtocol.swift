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
    var allCase: [Self] { get }
    var query: HashTagsQuery { get }
    
    func convertData(_ model: [PostsModel]) -> [PostsModel]
    func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel]
}

extension MainSection {
    
    func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel] {
        
        let sortedList = postList.sorted {
            guard let left = DateFormatManager.shared.stringToDate(value: $0.content4 ?? ""),
                  let right = DateFormatManager.shared.stringToDate(value: $1.content4 ?? "") else {
                return false
            }
            return left > right
        }

        var viewed: [PostsModel] = []
        sortedList.forEach { post in
            if viewed.last?.hashTags.first == post.hashTags.first {
                return
            }
            viewed.append(post)
        }
        return viewed
    }
    
}
