//
//  GeneralError.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation

enum GeneralError: Error {
  case noValidURL
  case responseWithError(code: Int)
  case unknownError
  case noFoundLocation
}
