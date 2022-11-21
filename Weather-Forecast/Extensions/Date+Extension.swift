//
//  Date+Extension.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import Foundation


extension Date {
  
  func isSame(date: Date) -> Bool {
    return Calendar(identifier: .gregorian).isDate(self, inSameDayAs: date)
  }
  
  var startDay: Date? {
    Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .calendar], from: self).date
  }
  
  func add(day: Int) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.day = day
    return Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self)
  }
  
}
