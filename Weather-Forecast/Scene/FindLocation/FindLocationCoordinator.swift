//
//  FindLocationCoordinator.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 17.11.2022.
//

import UIKit
import Swinject

class FindLocationCoordinator: BaseCoordinator {
  
  let navigationController: UINavigationController
  
  init(container: Container, navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init(container: container)
  }
  
  override func start() {
    let findLocationViewController = container.resolve(FindLocationViewController.self)!
    let findLocationViewModel = container.resolve(FindLocationViewModel.self, argument: self)
    findLocationViewController.viewModel = findLocationViewModel
    navigationController.pushViewController(findLocationViewController, animated: true)
  }
  
  func dismiss(locationAppModel: LocationAppModel) {
    if let weatherCoordinator = self.parentCoordinator as? WeatherCoordinator {
      weatherCoordinator.viewModel?.city = locationAppModel.city
    }
    self.navigationController.popViewController(animated: true)
  }
}
