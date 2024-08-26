//
//  MainCollectionViewSection.swift
//  Scrolly
//
//  Created by 유철원 on 8/23/24.
//

import Foundation

enum RecommandSection: String, MainSection {
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
        case .recently: "최근 본 작품"
        case .newWaitingFree: "기다무 신작"
        default: nil
        }
    }
    
    var allCase: [Self] {
        return Self.allCases
    }
    
    func convertData(_ section: RecommandSection, _ model: [PostsModel]) -> [PostsModel] {
        print(#function, section)
        switch section {
        case .banner:
            print(#function, "banner: ", model.count)
            return model.shuffled()
        case .popular:
            let sortedModel = model.sorted(by: { left, right in
                guard let lViewed = left.content3, let rViewed = right.content3,
                      let leftViewed = Int(lViewed), let rightViewd = Int(rViewed)  else {
                    return false
                }
                return leftViewed > rightViewd
            })
            print(#function, "popular: ", sortedModel.count)
            return Array<PostsModel>(sortedModel.prefix(6))
        case .recently:
            return setViewedNovel(model)
        default:
            return model
        }
        
    }
    
}
