//
//  WeatherWindResponse.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

struct WeatherWindResponse: Decodable {
  let speedMeterPerSec: Double
  let directionOfDegree: Int
  
  enum CodingKeys: String, CodingKey {
    case speedMeterPerSec = "speed"
    case directionOfDegree = "deg"
  }
}
