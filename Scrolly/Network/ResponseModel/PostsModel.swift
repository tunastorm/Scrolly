//
//  UploadPostsModel.swift
//  Scrolly
//
//  Created by 유철원 on 8/19/24.
//

import Foundation
import Differentiator

struct PostsModel: Decodable, Hashable, IdentifiableType {

    let id = UUID()
    let identity = UUID()
    let postId: String
    let productId: String
    let title: String?
    let price: Int?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    var content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [Comment]
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title, price, content, content1, content2, content3, content4, content5,
             createdAt, creator, files, likes, likes2, hashTags, comments
        case message
    }
    
    enum Day: CaseIterable {
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat
        case sun
        
        var kr: String {
            return switch self {
            case .mon: "월"
            case .tue: "화"
            case .wed: "수"
            case .thu: "목"
            case .fri: "금"
            case .sat: "토"
            case .sun: "일"
            }
        }
    }
    
    enum CountName: CaseIterable {
        case one
        case ten
        case hundred
        case thousand
        case tenThousand
        case hundredThousand
        case million
        case tenMillion
        case hundredMillion
        case billion
        
        var kr: String {
            switch self {
            case .one, .ten, .hundred, .thousand: ""
            case .tenThousand, .hundredThousand, .million, .tenMillion: "만"
            case .hundredMillion, .billion: "억"
            }
        }
    }
    
    var titleHashTag: String {
        hashTags.first?.replacing("_", with: " ") ?? ""
    }
    
    var creatorHashTag: String {
        guard hashTags.count > 0 else {
            return ""
        }
        return hashTags[1]
    }
    
    var dayList: [Int]? {
        content2?.replacing("[", with: "").replacing("]", with: "").split(separator: ",").map{ Int($0) ?? 0 }
    }
    
    var categorys: String {
        var category = ""
        if hashTags.count >= 3 {
            let tagString = hashTags[2...3].joined(separator: "﹒")
            category = "\(tagString)"
        }
        return category
    }
    
    var uploadDays: String {
        var continued: [[String]] = [[]]
        var listIdx = 0
        
        guard let dayList else {
            return "완결 "
        }
        
        var check: Set<Int> = []
        dayList.forEach { check.insert($0) }
        if check == [0] {
            return "완결 "
        } else if check == [1] {
           return "매일 연재"
        }
        
        dayList.enumerated().forEach { i, isUpload in
            if isUpload == 1 {
                continued[listIdx].append(Day.allCases[i].kr)
            } else {
                listIdx += 1
                continued.append(Array<String>())
            }
        }
        var uploadDays = ""
        continued.enumerated().forEach { idx, days in
            guard let first = days.first else {
                return
            }
            uploadDays += first
            if days.count > 1, let last = days.last {
                uploadDays += "~\(last)"
            }
            if idx < continued.count-1 {
                uploadDays += "﹒"
            }
        }
        return uploadDays + " 연재 "
    }
    
    var viewed: String {
        guard let raw = Int(content3 ?? "0"), let length = content3?.count else {
            return "0" + CountName.allCases[0].kr
        }
        let splited = raw.formatted().split(separator: ",")
        guard var viewed = splited.first, raw >= 10000 else {
            return content3 ?? "0" + CountName.allCases[0].kr
        }
        switch viewed.count {
        case 1:
            let prefixed = String(splited[1].prefix(2))
            guard let first = prefixed.first, let last = prefixed.last else {
                return "0" + CountName.allCases[length - 1].kr
            }
            viewed = splited.count % 2 == 1 ?
                        viewed + prefixed + ".\(splited[1].suffix(1))" : viewed + String(first) + "." + String(last)
        case 2:
            viewed = splited.count % 2 == 1 ?
            "\(viewed.prefix(1)),\(viewed.suffix(1))\(splited[1].prefix(2)).\(splited[1].suffix(1))"
            : "\(viewed.prefix(1)).\(viewed.suffix(1))"
        case 3:
            let prefixed = viewed.prefix(2)
            guard let first = prefixed.first, var last = prefixed.last else {
                return "0" + CountName.allCases[0].kr
            }
            viewed = splited.count % 2 == 1 ?
            String(first) + "." + String(last) : prefixed + ".\(viewed.suffix(1))"
        default: return "0" + CountName.allCases[0].kr
        }
        viewed = viewed.suffix(1) == "0" ? viewed.replacing(".0", with: "") : viewed
        return viewed + CountName.allCases[length - 1].kr
    }
    
    init() {
        self.postId = "blanck"
        self.productId = "blacnkProduct"
        self.title = nil
        self.price = nil
        self.content = nil
        self.content1 = nil
        self.content2 = nil
        self.content3 = nil
        self.content4 = nil
        self.content5 = nil
        self.createdAt = ""
        self.creator = Creator()
        self.files = []
        self.likes = []
        self.likes2 = []
        self.hashTags = []
        self.comments = []
        self.message = nil
        
    }
    
}

struct Creator: Decodable, Hashable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
    
    init() {
        self.userId = ""
        self.nick = ""
        self.profileImage = nil
    }
}

struct Comment: Decodable, Hashable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content, createdAt, creator
    }
}
