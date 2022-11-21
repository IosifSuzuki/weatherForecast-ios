//
//  LocationService.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import Foundation
import RxSwift
import MapKit

protocol LocationService {
  var currentUserLocation: Observable<CLLocation> { get }
  
  func requestAuthorization()
  func autocompleteCity(text: String) -> Observable<[LocationAppModel]>
  func findLocation(coordinate: CLLocation) -> Observable<LocationAppModel>
}

class DiscoverLocationService: NSObject, LocationService, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate {
  let searchLocation = MKLocalSearchCompleter()
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    
    locationManager.delegate = self
    searchLocation.delegate = self
  }
  
  var currentUserLocation: Observable<CLLocation> {
    locationManager.startUpdatingLocation()
    return rx
      .sentMessage(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
      .compactMap { args in
        return (args[1] as? [CLLocation])?.first
      }
  }
  
  func requestAuthorization() {
    locationManager.requestAlwaysAuthorization()
  }
  
  func autocompleteCity(text: String) -> Observable<[LocationAppModel]> {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = text
    let search = MKLocalSearch(request: request)
    return Observable.create { observer in
      search.start { response, _ in
        guard let response = response else {
          observer.on(.next([]))
          return
        }
        let dataSource = response.mapItems.compactMap { mapItem -> LocationAppModel? in
          let country = mapItem.placemark.country
          let city = mapItem.placemark.name
          guard let country = country, let city = city, city.count < 15 else {
            return nil
          }
          return LocationAppModel(city: city, country: country)
        }
        observer.on(.next(Array(Set(dataSource))))
      }
      return Disposables.create()
    }
  }
  
  func findLocation(coordinate: CLLocation) -> Observable<LocationAppModel> {
    let geocooder = CLGeocoder()
    return Observable.create { observer in
      geocooder.reverseGeocodeLocation(coordinate) { places, error in
        guard let city = places?.first?.subAdministrativeArea, let country = places?.first?.country else {
          observer.onError(GeneralError.noFoundLocation)
          return
        }
        observer.on(.next(LocationAppModel(city: city, country: country)))
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
  }
}
