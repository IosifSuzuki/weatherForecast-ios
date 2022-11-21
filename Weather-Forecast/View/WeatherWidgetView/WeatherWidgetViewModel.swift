//
//  WeatherWidgetViewModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation
import UIKit

enum WindDirection: Int {
  case n
  case ne
  case e
  case es
  case s
  case sw
  case w
  case wn
  
  init?(degree: Int) {
    let offset = Int(round((Double(degree) + 22.5) / 90))
    guard let windDirection = WindDirection(rawValue: offset) else {
      return nil
    }
    self = windDirection
  }
  
  var arrowImageView: UIImage? {
    switch self {
    case .n:
      return UIImage(systemName: "arrow.up")
    case .ne:
      return UIImage(systemName: "arrow.up.right")
    case .e:
      return UIImage(systemName: "arrow.right")
    case .es:
      return UIImage(systemName: "arrow.down.right")
    case .s:
      return UIImage(systemName: "arrow.down")
    case .sw:
      return UIImage(systemName: "arrow.down.left")
    case .w:
      return UIImage(systemName: "arrow.left")
    case .wn:
      return UIImage(systemName: "arrow.up.left")
    }
  }
}

class WeatherWidgetViewModel: WeatherWidgetRepresentable {
  
  private let weatherDetailAppModel: WeatherDetailAppModel
  private let weatherService: WeatherService
  
  var dateTextRepresentable: String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E dd, MMMM"
    return dateFormatter.string(from: weatherDetailAppModel.weatherDetailResponses.first?.date ?? Date())
  }
  
  var temperatureTextRepresentable: String? {
    let minTmp = weatherDetailAppModel.weatherDetailResponses.map {$0.mainWeather.temp}.min()
    let maxTmp = weatherDetailAppModel.weatherDetailResponses.map {$0.mainWeather.temp}.max()
    guard let minTmp = minTmp, let maxTmp = maxTmp else {
      return nil
    }
    return String(format: "%02d°/%02d°", Int(minTmp), Int(maxTmp))
  }
  
  var humidityTextRepresentable: String {
    let averageHumidity = weatherDetailAppModel.weatherDetailResponses.map { weatherDetailResponse in
      return weatherDetailResponse.mainWeather.humidity
    }.reduce(0) { partialResult, humidity in
      return partialResult + humidity / weatherDetailAppModel.weatherDetailResponses.count
    }
    return String(format: "%02d%%", averageHumidity)
  }
  
  var nowWeatherDetailResponse: WeatherDetailResponse? {
    return weatherDetailAppModel.weatherDetailResponses.first { weatherDetailResponse in
      weatherDetailResponse.date > Date.now
    } ?? weatherDetailAppModel.weatherDetailResponses.first
  }
  
  var windSpeedTextRepresentable: String? {
    guard let speedMeterPerSec = nowWeatherDetailResponse?.wind.speedMeterPerSec else {
      return nil
    }
    let measurement = Measurement(value: speedMeterPerSec, unit: UnitSpeed.metersPerSecond)
    let measurementFormatter = MeasurementFormatter()
    measurementFormatter.unitOptions = .providedUnit
    measurementFormatter.unitStyle = .short
    measurementFormatter.numberFormatter.maximumFractionDigits = 2
    return measurementFormatter.string(from: measurement)
  }
  
  var windDirection: WindDirection? {
    guard let directionOfDegree = nowWeatherDetailResponse?.wind.directionOfDegree else {
      return nil
    }
    return WindDirection(degree: directionOfDegree)
  }
  
  var weatherIconURL: URL? {
    guard let iconReference = nowWeatherDetailResponse?.weather.first?.iconReference else {
      return nil
    }
    return weatherService.getWeatherUrlPath(iconRef: iconReference)
  }
  
  init(weatherDetailAppModel: WeatherDetailAppModel, weatherService: WeatherService) {
    self.weatherDetailAppModel = weatherDetailAppModel
    self.weatherService = weatherService
  }
  
}
