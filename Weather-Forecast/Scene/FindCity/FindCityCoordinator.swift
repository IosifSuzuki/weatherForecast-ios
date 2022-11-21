//
//  FindCityCoordinator.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import UIKit
import Swinject

class FindCityCoordinator: BaseCoordinator {
  
  let navigationController: UINavigationController
  
  init(container: Container, navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init(container: container)
  }
  
  override func start() {
    let findCityViewController = container.resolve(FindCityViewController.self)!
    let findCityViewModel = container.resolve(FindCityViewModel.self, argument: self)
    findCityViewController.viewModel = findCityViewModel
    navigationController.pushViewController(findCityViewController, animated: true)
  }
  
  // MARK: - Private Methods
  
  
  func dismiss(locationAppModel: LocationAppModel) {
    if let weatherCoordinator = self.parentCoordinator as? WeatherCoordinator {
      weatherCoordinator.viewModel?.city = locationAppModel.city
    }
    self.navigationController.popViewController(animated: true)
  }
}
