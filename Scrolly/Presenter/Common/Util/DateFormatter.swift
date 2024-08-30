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
        case .dateAndTimeWithTimezone: "yyyy-MM-ddEEEEEHH-mm-ssZ"
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
        print("date: ", worker.date(from: value))
        guard let beforeDate = worker.date(from: value) else {
            return ""
        }
        worker.dateFormat = after.formatString
        return worker.string(from: beforeDate)
    }
    
}
