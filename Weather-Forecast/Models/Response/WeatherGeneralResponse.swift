//
//  GeneralWeatherResponse.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

struct WeatherGeneralResponse: Decodable {
  let weathers: [WeatherDetailResponse]
  
  enum CodingKeys: String, CodingKey {
    case weathers = "list"
  }
  
  init(weathers: [WeatherDetailResponse]) {
    self.weathers = weathers
  }
  
  init() {
    self.weathers = []
  }
  
}
