//
//  WeatherComponentCollectionCellViewModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import Foundation

class WeatherComponentCollectionCellViewModel: WeatherComponentCollectionCellViewModelRepresentable {
  
  private let weatherDetailResponse: WeatherDetailResponse
  private let weatherService: WeatherService
  
  var hourTextRepresentable: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    return dateFormatter.string(from: weatherDetailResponse.date)
  }
  
  var minuteTextRepresentable: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm"
    return dateFormatter.string(from: weatherDetailResponse.date)
  }
  
  var weatherIconURL: URL? {
    guard let iconReference = weatherDetailResponse.weather.first?.iconReference else {
      return nil
    }
    return weatherService.getWeatherUrlPath(iconRef: iconReference)
  }
  
  var temperatureTextRepresentable: String {
    return String(format: "%02d°", Int(weatherDetailResponse.mainWeather.temp))
  }
  
  init(weatherDetailResponse: WeatherDetailResponse, weatherService: WeatherService) {
    self.weatherDetailResponse = weatherDetailResponse
    self.weatherService = weatherService
  }
  
  
}
