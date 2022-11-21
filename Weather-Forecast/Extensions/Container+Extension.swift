//
//  Container+Extension.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
  func registerDependencies() {
    registerServices()
    registerCoordinators()
    registerViewModels()
    registerViewControllers()
  }
}

private extension Container {
  
  func registerServices() {
    autoregister(Theme.self, initializer: ThemeManager.init)
    autoregister(Config.self, initializer: Config.init)
    autoregister(WeatherService.self, initializer: RemoteWeatherService.init)
    autoregister(LocationService.self, initializer: DiscoverLocationService.init)
  }
  
  func registerViewModels() {
    autoregister(WeatherViewModel.self, argument:WeatherCoordinator.self, initializer: WeatherViewModel.init)
    autoregister(FindCityViewModel.self, argument:FindCityCoordinator.self, initializer: FindCityViewModel.init)
    autoregister(FindLocationViewModel.self, argument:FindLocationCoordinator.self, initializer: FindLocationViewModel.init)
  }
  
  func registerCoordinators() {
    autoregister(WeatherCoordinator.self, arguments: Container.self, UINavigationController.self, initializer: WeatherCoordinator.init)
    autoregister(FindCityCoordinator.self, arguments: Container.self, UINavigationController.self, initializer: FindCityCoordinator.init)
    autoregister(FindLocationCoordinator.self, arguments: Container.self, UINavigationController.self, initializer: FindLocationCoordinator.init)
  }
  
  func registerViewControllers() {
    registerViewController(WeatherViewController.self) { r, c in
      c.viewModel = r~>
      c.theme = r~>
    }
    registerViewController(FindCityViewController.self) { r, c in
      c.viewModel = r~>
      c.theme = r~>
    }
    registerViewController(FindLocationViewController.self) { r, c in
      c.viewModel = r~>
      c.theme = r~>
    }
  }
  
  @discardableResult
  func registerViewController<ViewController>(_ controllerType: ViewController.Type, initCompleted: ((Swinject.Resolver, ViewController) -> Void)?  = nil) -> Swinject.ServiceEntry<ViewController> {
      return register(ViewController.self) { r in
          let storyboardName = "\(controllerType)".replacingOccurrences(of: "ViewController", with: "")
          let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
          let viewController = storyboard.instantiateInitialViewController() as! ViewController
          initCompleted?(r, viewController)
          return viewController
      }
  }
}
