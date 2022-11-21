//
//  FindLocationViewModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 17.11.2022.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa


class FindLocationViewModel: ViewModel {
  
  var coordinator: FindLocationCoordinator
  var locationService: LocationService
  let disposedBag: DisposeBag = .init()
  
  init(coordinator: FindLocationCoordinator, LocationService: LocationService) {
    self.coordinator = coordinator
    self.locationService = LocationService
  }
  
  func transform(input: Input) -> Output {
    locationService.requestAuthorization()
    input.selectedLocation.subscribe(onNext: { [weak self] location in
      let geocoder = CLGeocoder()
      let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
      geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard let placemarks = placemarks, error == nil else {
          return
        }
        let placemark = placemarks.first { placemark in
          let city = placemark.name
          let coutry = placemark.country
          return city != nil && coutry != nil
        }
        guard let placemark = placemark, let city = placemark.locality, let coutry = placemark.country else {
          return
        }
        let locationAppModel = LocationAppModel(city: city, country: coutry)
        self?.coordinator.dismiss(locationAppModel: locationAppModel)
      }
    }).disposed(by: self.disposedBag)
    
    let userLocation = self.locationService.currentUserLocation
      .skip { location in
        location.horizontalAccuracy > kCLLocationAccuracyHundredMeters
      }
      .take(until: input.didPinLocation)
      .map { location in
        location.coordinate
      }.asDriver { error in
        return Driver<CLLocationCoordinate2D>.empty()
      }
    
    let enableNextStep = Observable.of(
      input.didPinLocation.map { _ in true },
      self.locationService.currentUserLocation.map { _ in true }
    )
      .startWith(.just(false), .just(false))
      .merge()
      .asDriver(onErrorJustReturn: true)
    
    return .init(enableNextStep: enableNextStep, userLocation: userLocation)
  }
  
  struct Input {
    let didPinLocation: Observable<CLLocationCoordinate2D>
    let selectedLocation: Observable<CLLocationCoordinate2D>
  }
  
  struct Output {
    let enableNextStep: Driver<Bool>
    let userLocation: Driver<CLLocationCoordinate2D>
  }
  
}
