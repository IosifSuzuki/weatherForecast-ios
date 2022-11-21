//
//  WeatherResponse.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

struct WeatherDetailResponse: Decodable {
  
  let mainWeather: WeatherMainResponse
  let weather: [WeatherResponse]
  let wind: WeatherWindResponse
  let date: Date
  
  enum CodingKeys: String, CodingKey {
    case mainWeather = "main"
    case weather = "weather"
    case wind = "wind"
    case date = "dt_txt"
  }
}
