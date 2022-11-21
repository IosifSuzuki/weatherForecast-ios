//
//  WeatherCoordinator.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation
import Swinject

class WeatherCoordinator: BaseCoordinator {

  let navigationController: UINavigationController
  var viewModel: WeatherViewModel?
  
  init(container: Container, navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init(container: container)
  }
  
  override func start() {
    let weatherViewController = container.resolve(WeatherViewController.self)!
    let weatherViewModel = container.resolve(WeatherViewModel.self, argument: self)
    self.viewModel =  weatherViewModel
    weatherViewController.viewModel = weatherViewModel
    weatherViewController.navigationItem.backButtonTitle = ""
    navigationController.setViewControllers([weatherViewController], animated: false)
  }
  
  func searchLocationByText() {
    let findCityCoordinator = FindCityCoordinator(
      container: container,
      navigationController: navigationController
    )
    start(coordinator: findCityCoordinator)
  }
  
  func searchCityByLocation() {
    let findLocationCoordinator = FindLocationCoordinator(
      container: container,
      navigationController: navigationController
    )
    start(coordinator: findLocationCoordinator)
  }
  
  func showAlert(with title: String, error: String) {
    let alertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    navigationController.topViewController?.present(alertController, animated: true)
  }
}
