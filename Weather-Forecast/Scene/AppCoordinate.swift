//
//  AppCoordinate.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation
import RxSwift
import Swinject

class AppCoordinate: BaseCoordinator {
  
  var window: UIWindow
  
  init(window: UIWindow, container: Container) {
    self.window = window
    super.init(container: container)
  }
  
  override func start() {
    let weatherCoordinator = container.resolve(WeatherCoordinator.self, arguments: container, UINavigationController())!
    start(coordinator: weatherCoordinator)
    window.rootViewController = weatherCoordinator.navigationController
    window.makeKeyAndVisible()
  }
  
}
