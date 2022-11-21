//
//  LocationCityBarButtonItem.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 15.11.2022.
//

import UIKit
import RxCocoa
import RxSwift

class LocationCityBarButtonItem: UIBarButtonItem, ThemeDependency {
  
  var tap: Driver<Void>
  private let tapAction: PublishRelay<Void> = .init()
  
  private var locationPinButton: UIButton
  var titleCity: String? {
    didSet {
      guard let titleCity = titleCity else {
        return
      }
      locationPinButton.configuration = prepareConfiguration(with: titleCity)
      locationPinButton.sizeToFit()
    }
  }
  
  var bagDisposed: DisposeBag = .init()
  
  init(titleCity: String?) {
    let cityButton = UIButton()
    self.locationPinButton = cityButton
    self.tap = Observable.merge(cityButton.rx.tap.asObservable(), tapAction.asObservable()).asDriver(onErrorJustReturn: ())
    super.init()
    cityButton.configuration = prepareConfiguration(with: titleCity ?? "")
    self.customView = cityButton
    
  }
  
  private func prepareConfiguration(with title: String) -> UIButton.Configuration {
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage(
      systemName: "mappin",
      withConfiguration: UIImage.SymbolConfiguration(scale: .large)
    )
    configuration.imagePlacement = .leading
    configuration.imagePadding = 8
    configuration.contentInsets = .zero
    configuration.title = title
    return configuration
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ThemeDependency
  
  func apply(theme: Theme) {
    tintColor = theme.textColorOnDarkBackground
    locationPinButton.tintColor = theme.textColorOnDarkBackground
  }
  
}
