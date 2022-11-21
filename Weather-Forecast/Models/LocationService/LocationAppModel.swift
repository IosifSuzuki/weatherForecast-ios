//
//  LocationAppModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import Foundation

struct LocationAppModel: Hashable {
  let city: String
  let country: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(city)
    hasher.combine(country)
  }
}
