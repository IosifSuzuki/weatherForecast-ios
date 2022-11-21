//
//  WeatherResponse.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

struct WeatherResponse: Decodable {
  let id: Int
  let main: String
  let description: String?
  let iconReference: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case main
    case description
    case iconReference = "icon"
  }
}
