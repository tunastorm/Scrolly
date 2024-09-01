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
    
    func callConvertData<T: MainSection>(_ section: T, _ model: [PostsModel]) -> [PostsModel]
    
    func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel]
}


extension MainSection {
    
    func callConvertData<T: MainSection>(_ section: T, _ model: [PostsModel]) -> [PostsModel] {
        switch section {
        case is RecommandSection:
            guard let recommand = section as? RecommandSection else {
                return []
            }
            return recommand.convertData(recommand, model)
        case is MaleSection:
            guard let male = section as? MaleSection else {
                return []
            }
            return male.convertData(male, model)
        case is FemaleSection:
            guard let female = section as? FemaleSection else {
                return []
            }
            return female.convertData(female, model)
        case is FantasySection:
            guard let fantasy = section as? FantasySection else {
                return []
            }
            return fantasy.convertData(fantasy, model)
        case is RomanceSection:
            guard let romance = section as? RomanceSection else {
                return []
            }
            return romance.convertData(romance, model)
        case is DateSection:
            guard let date = section as? DateSection else {
                return []
            }
            return date.convertData(date, model)
        default: return []
        }
    }
    
    func setViewedNovel(_ postList: [PostsModel]) -> [PostsModel] {
        var viewed: [PostsModel] = []
        var sortedList = postList.sorted {
            guard let left = DateFormatManager.shared.stringToDate(value: $0.content4 ?? ""),
                  let right = DateFormatManager.shared.stringToDate(value: $1.content4 ?? "") else {
                return false
            }
            print(#function, "left: ", left)
            print(#function, "right: ", right)
            return left > right
        }
//        print(#function, "sortedList: ", sortedList)
        sortedList.forEach { post in
            if viewed.last?.hashTags.first == post.hashTags.first {
                return
            }
            viewed.append(post)
        }
        return viewed
    }
    
}
