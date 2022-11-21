//
//  Coordinator.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation
import Swinject
import RxSwift

protocol Coordinator: AnyObject {
  var parentCoordinator: Coordinator? { get set }
  var container: Container { get }
  
  func start()
  func start(coordinator: Coordinator)
  func didFinish(coordinator: Coordinator)
  func removeChildCoordinators()
}

class BaseCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    var container: Container
  
    init(container: Container) {
      self.container = container
    }
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach {
          $0.removeChildCoordinators()
        }
        childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
