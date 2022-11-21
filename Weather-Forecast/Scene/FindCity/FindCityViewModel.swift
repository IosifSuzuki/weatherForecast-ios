//
//  FindCityViewModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

class FindCityViewModel: ViewModel {
  
  var coordinator: FindCityCoordinator
  var locationService: LocationService
  let disboseBag: DisposeBag = .init()
  
  init(coordinator: FindCityCoordinator, locationService: LocationService) {
    self.coordinator = coordinator
    self.locationService = locationService
  }
  
  func transform(input: Input) -> Output {
    let dataSourceDriver = input.searchTextTrigger
      .asObservable()
      .flatMap { text -> Observable<[LocationAppModel]> in
        return self.locationService.autocompleteCity(text: text)
      }
      .map { dataSource in
        dataSource.map { locationAppModel in
           CityTableViewModel(
            city: locationAppModel.city,
            country: locationAppModel.country
          )
        }
      }
    input.selectLocationTrigger.drive(onNext: { [weak self] locationAppModel in
      self?.coordinator.dismiss(locationAppModel: locationAppModel)
    })
    .disposed(by: self.disboseBag)
    return .init(
      dataSourceDidChanged: dataSourceDriver.asDriver(onErrorJustReturn: [])
    )
  }
  
  struct Input {
    let searchTextTrigger: Driver<String>
    let selectLocationTrigger: Driver<LocationAppModel>
  }
  
  struct Output {
    let dataSourceDidChanged: Driver<[CityTableViewModel]>
  }
  
}
