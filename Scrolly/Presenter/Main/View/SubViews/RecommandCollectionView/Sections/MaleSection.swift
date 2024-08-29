//
//  MaleSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/25/24.
//

import Foundation

enum MaleSection: String, MainSection {
    case banner
    case popular
    case recently
    case newWaitingFree
    
    var value: String {
        return self.rawValue
    }
    
    var index: Int {
        return switch self {
        case .banner: 0
        case .popular: 1
        case .recently: 2
        case .newWaitingFree: 3
        }
    }
    
    var header: String? {
        return switch self {
        case .newWaitingFree: "기다무 신작"
        case .recently: "최근 본 작품"
        default: nil
        }
    }
    
    var allCase: [Self] {
        return Self.allCases
    }
    
    var query: HashTagsQuery {
        return switch self {
        case .banner, .popular, .newWaitingFree:
            HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelInfo, hashTag: APIConstants.SearchKeyword.male)
        case .recently:
            HashTagsQuery(next: nil, limit: "10", productId: APIConstants.ProductId.novelEpisode, hashTag: APIConstants.SearchKeyword.male)
        }
    }
    
    func convertData(_ section: MaleSection, _ model: [PostsModel]) -> [PostsModel] {
        print(self.self, #function, "section: ", section)
        print(self.self, #function, "model: ", model.count)
        switch section {
        case .banner:
            return model.shuffled()
        case .popular:
            let sortedModel = model.sorted(by: { left, right in
                guard let lViewed = left.content3, let rViewed = right.content3,
                      let leftViewed = Int(lViewed), let rightViewd = Int(rViewed)  else {
                    return false
                }
                return leftViewed > rightViewd
            })
            return Array<PostsModel>(sortedModel.prefix(6))
        case .newWaitingFree:
            return model.filter{($0.content1 ?? "false").contains("true") }
        case .recently:
            return setViewedNovel(model)
        }
        
    }
    
}
