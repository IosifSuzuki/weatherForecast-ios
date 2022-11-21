//
//  WeatherMainResponse.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

struct WeatherMainResponse: Decodable {
  let temp: Double
  let humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case humidity
  }
}
