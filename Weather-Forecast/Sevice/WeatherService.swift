//
//  WeatherService.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol WeatherService {
  func getWeather(by city: String) -> Observable<WeatherGeneralResponse>
  func getWeather(lat: Float64, lot: Float64) -> Observable<WeatherGeneralResponse>
  func getWeatherUrlPath(iconRef: String) -> URL?
}

class RemoteWeatherService: WeatherService {
  
  let config: Config
  var disposeBag: DisposeBag = .init()
  
  init(config: Config) {
    self.config = config
  }
  
  func getWeather(by city: String) -> Observable<WeatherGeneralResponse> {
    guard let url = Path.weather.url,
          var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return Observable<WeatherGeneralResponse>.create(error: GeneralError.noValidURL)
    }
    urlComponents.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "appid", value: config.weatherAPIKey),
      URLQueryItem(name: "units", value: "metric"),
    ]
    guard let transformedURL = urlComponents.url else {
        return Observable<WeatherGeneralResponse>.create(error: GeneralError.noValidURL)
    }
    var request = URLRequest(url: transformedURL)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = [
      "Content-Type": "application/json"
    ]
    return Observable.create { observer in
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse else {
          observer.onError(error ?? GeneralError.unknownError)
          return
        }
        if !(200..<300).contains(response.statusCode) {
          observer.onError(GeneralError.responseWithError(code: response.statusCode))
          return
        }
        do {
          let jsonDecoder = JSONDecoder()
          jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateTxt = try container.decode(String.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let parsedDate = dateFormatter.date(from: dateTxt) else {
              throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateTxt)")
            }
            return parsedDate
          })
          let weaterResponse = try jsonDecoder.decode(WeatherGeneralResponse.self, from: data)
          observer.onNext(weaterResponse)
          observer.onCompleted()
        } catch {
          observer.onError(error)
        }
      }
      task.resume()
      return Disposables.create {
        task.cancel()
      }
    }
  }
  
  func getWeather(lat: Float64, lot: Float64) -> Observable<WeatherGeneralResponse> {
    return Observable.create(error: GeneralError.unknownError)
  }
  
  func getWeatherUrlPath(iconRef: String) -> URL? {
    guard var path = Path.weatherIconResource.url else {
      return nil
    }
    path.appendPathComponent("\(iconRef)@2x.png")
    return path
  }
  
  enum Path: String {
    case weather = "https://api.openweathermap.org/data/2.5/forecast"
    case weatherIconResource = "https://openweathermap.org/img/wn"
    
    var url: URL? {
      return .init(string: self.rawValue)
    }
  }
  
}
