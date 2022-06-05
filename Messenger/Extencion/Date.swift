//
//  Date.swift
//  Messenger
//
//  Created by Pavel Sharkov on 05.06.2022.
//

import Foundation

enum DateFormatEnum: String {
    /// Style:  yyyy-MM-dd'T'HH:mm:ssZ
    case fromServer = "yyyy-MM-dd'T'HH:mm:ssZ"
    /// Style:  yyyy-MM-dd HH:mm:ss
    case forServer = "yyyy-MM-dd HH:mm:ss"
    /// Style:  yyyy-MM-dd HH:mm:ss
    case newForServer = "yyyy-MM-dd HH:mm"
    /// Style:  yyyy-MM-dd
    case toServer = "yyyy-MM-dd"
    /// Style:  dd.MM.yyyy
    case defaultDesign = "dd.MM.yyyy"
    /// Style:  dd MMM
    case dayAndMonth = "dd MMM"
    /// Style:  HH:mm
    case time = "HH:mm"
    /// Style:  MM-dd
    case monthAndDay = "MM-dd"
    /// Style:  MM-yyyy
    case monthId = "MM-yyyy"
    /// Style:  yyy-MM-dd
    case yearMonthDay = "yyy-MM-dd"
    /// Style:  MM
    case monthTitleId = "MM"
    /// Style:  yyyy
    case year = "yyyy"
}

private let formatter = DateFormatter()
private let dateISOFormatter = ISO8601DateFormatter()

extension Date {
    func string(with format: DateFormatEnum) -> String {
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func compareDateAndTime(start: Date, end: Date, format: DateFormatEnum) -> String {
        let startDate = start.string(with: format)
        let endDate = end.string(with: format)
        return "\(startDate) - \(endDate)"
    }
}

extension Date {
    func getISODateDafult(from isoString: String, format: DateFormatEnum) -> String {
        dateISOFormatter.formatOptions = [
            .withFullDate,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]

        guard let date = dateISOFormatter.date(from: isoString) else { return ""}
        return date.string(with: format)
    }
    
    func getISODate(from isoString: String, format: DateFormatEnum) -> String {
        dateISOFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        guard let date = dateISOFormatter.date(from: isoString) else { return ""}
        return date.string(with: format)
    }
    
    // get array Dates between two dates
      
      static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
          var dates: [Date] = []
          var date = fromDate
          
          while date <= toDate {
              dates.append(date)
              guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
              date = newDate
          }
          return dates
      }
}
