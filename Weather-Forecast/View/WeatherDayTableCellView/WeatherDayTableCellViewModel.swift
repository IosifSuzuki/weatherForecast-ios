//
//  WeatherDayTableViewCellModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import Foundation

class WeatherDayTableCellViewModel: WeatherDayTableCellViewModelRepresentable {
  
  let weatherDetailAppModel: WeatherDetailAppModel
  private let weatherService: WeatherService
  
  init(weatherDetailAppModel: WeatherDetailAppModel, weatherService: WeatherService) {
    self.weatherDetailAppModel = weatherDetailAppModel
    self.weatherService = weatherService
  }
  
  var dayTextRepresentable: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    return dateFormatter.string(from: weatherDetailAppModel.weatherDetailResponses.first?.date ?? Date()).uppercased()
  }
  
  var temperatureTextRepresentable: String? {
    let minTmp = weatherDetailAppModel.weatherDetailResponses.map {$0.mainWeather.temp}.min()
    let maxTmp = weatherDetailAppModel.weatherDetailResponses.map {$0.mainWeather.temp}.max()
    guard let minTmp = minTmp, let maxTmp = maxTmp else {
      return nil
    }
    return String(format: "%02d°/%02d°", Int(minTmp), Int(maxTmp))
  }
  
  var weatherIconPath: URL? {
    guard let iconReference = weatherDetailAppModel.weatherDetailResponses.first?.weather.first?.iconReference else {
      return nil
    }
    return weatherService.getWeatherUrlPath(iconRef: iconReference)
  }
  
}
