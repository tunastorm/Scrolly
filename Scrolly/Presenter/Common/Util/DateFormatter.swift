//
//  DateFormatter.swift
//  Scrolly
//
//  Created by 유철원 on 8/28/24.
//

import Foundation

enum DateFormat {
    case dateAndTimeWithTimezone
    case dotSperatedyyyMMdd
    
    var formatString: String {
        return switch self {
        case .dateAndTimeWithTimezone: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .dotSperatedyyyMMdd:  "yyyy.MM.dd"
        }
    }
}

protocol DateFormatterProvider {
    
    func stringToformattedString(value: String, before: DateFormat, after: DateFormat) -> String
    
}


final class DateFormatManager: DateFormatterProvider {
    
    static let shared = DateFormatManager()
    
    private init() {}
    
    private let worker = DateFormatter()

    func stringToformattedString(value: String, before: DateFormat, after: DateFormat) -> String {
        worker.dateFormat = before.formatString
        guard let beforeDate = worker.date(from: value) else {
            return ""
        }
        worker.dateFormat = after.formatString
        return worker.string(from: beforeDate)
    }
    
    func nowString() -> String {
        worker.dateFormat = DateFormat.dateAndTimeWithTimezone.formatString
        let now = worker.string(from: Date())
        return now
    }
    
    func stringToDate(value: String) -> Date? {
        worker.dateFormat = DateFormat.dateAndTimeWithTimezone.formatString
        return worker.date(from: value)
    }
    
}
