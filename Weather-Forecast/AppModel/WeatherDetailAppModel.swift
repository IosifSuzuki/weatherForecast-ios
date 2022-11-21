//
//  WeatherDetailAppModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation

struct WeatherDetailAppModel {
  let dayDate: Date
  let weatherDetailResponses: [WeatherDetailResponse]
  
  // MARK: - Initializers
  
  init?(dayDate: Date, weatherDetailResponses: [WeatherDetailResponse]) {
    guard let correctedDate = dayDate.startDay else {
      return nil
    }
    let containsWeatherDetailResponses = weatherDetailResponses.contains { weatherDetailResponse in
      correctedDate.isSame(date: weatherDetailResponse.date)
    }
    if containsWeatherDetailResponses {
      self.dayDate = correctedDate
      self.weatherDetailResponses = Self.filter(weatherDetailResponses: weatherDetailResponses, by: correctedDate)
    } else if let nextDayDate = correctedDate.add(day: 1) {
      self.dayDate = nextDayDate
      self.weatherDetailResponses = Self.filter(weatherDetailResponses: weatherDetailResponses, by: nextDayDate)
    } else {
      return nil
    }
  }
  
  // MARK: - Public Methods
  
  static func filter(weatherDetailResponses: [WeatherDetailResponse], by date: Date) -> [WeatherDetailResponse] {
    return weatherDetailResponses.filter { weatherDetailResponse in
      date.isSame(date: weatherDetailResponse.date)
    }
  }
  
  static func seperateWeatherDetailResponsesByDay(weatherDetailResponses: [WeatherDetailResponse]) -> [WeatherDetailAppModel] {
    var resultDataSource: [WeatherDetailAppModel] = []
    var weatherDetailResponses = weatherDetailResponses
    while !weatherDetailResponses.isEmpty {
      guard let startDate = weatherDetailResponses.first?.date.startDay else {
        break
      }
      let filteredWeatherDetailResponses = weatherDetailResponses.filter { weatherDetailResponse in
        weatherDetailResponse.date.startDay?.isSame(date: startDate) ?? false
      }
      if let weatherDetailAppModel = WeatherDetailAppModel(dayDate: startDate, weatherDetailResponses: filteredWeatherDetailResponses) {
        resultDataSource.append(weatherDetailAppModel)
      }
      weatherDetailResponses.removeAll { $0.date.isSame(date: startDate) }
    }
    return resultDataSource
  }
  
}
