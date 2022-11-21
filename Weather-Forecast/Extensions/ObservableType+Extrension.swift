//
//  ObservableType+Extrension.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation
import RxSwift

extension ObservableType {
  
  static func create(error: Error) -> Observable<Element> {
    return Observable<Element>.create { observer in
      observer.onError(error)
      return Disposables.create()
    }
  }
  
}
