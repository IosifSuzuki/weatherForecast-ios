//
//  WeatherForecastViewModelImpl.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel: ViewModel {
  let coordinator: WeatherCoordinator
  let weatherService: WeatherService
  let config: Config
  
  var city: String? {
    didSet {
      guard let city = city else {
        return
      }
      citySubject.accept(city)
    }
  }
  let citySubject: PublishRelay<String> = .init()
  
  let disposeBag = DisposeBag()
  
  init(coordinator: WeatherCoordinator, weatherService: WeatherService, config: Config) {
    self.coordinator = coordinator
    self.weatherService = weatherService
    self.config = config
  }
  
  func transform(input: Input) -> Output {
    city = config.defaultSearchCity
    input.findCityTrigger.drive(onNext: { [weak self] _ in
      self?.coordinator.searchLocationByText()
    }).disposed(by: self.disposeBag)
    input.findLocationTrigger.drive(onNext: { [weak self] _ in
      self?.coordinator.searchCityByLocation()
    }).disposed(by: self.disposeBag)
    let errorDescriptionSubject: PublishRelay<String> = .init()
    let weatherGeneralResponse = input
      .loadWeatherDataTrigger
      .asObservable()
      .flatMapLatest { [weak self] _ in
        guard let self = self, let city = self.city else {
          return Observable<WeatherGeneralResponse>.empty()
        }
        return self.weatherService.getWeather(by: city)
          .do(onError: { error in
            errorDescriptionSubject.accept("Cannot found the city")
          })
          .catch { error in
            return Observable<WeatherGeneralResponse>.empty()
          }
      }
      .share(replay: 1, scope: .whileConnected)
    errorDescriptionSubject
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] errorText in
        self?.coordinator.showAlert(with: "Error", error: errorText)
      })
      .disposed(by: self.disposeBag)
    let weatherWidgetViewModelSubject: PublishRelay<WeatherWidgetViewModel> = .init()
    weatherGeneralResponse
      .compactMap { weatherGeneralResponse in
        return WeatherDetailAppModel(dayDate: .now, weatherDetailResponses: weatherGeneralResponse.weathers)
      }
      .compactMap { [weak self] weatherDetailAppModel -> WeatherWidgetViewModel? in
        guard let self = self else {
          return nil
        }
        return WeatherWidgetViewModel(weatherDetailAppModel: weatherDetailAppModel, weatherService: self.weatherService)
      }
      .subscribe(onNext: { weatherWidgetViewModel in
        weatherWidgetViewModelSubject.accept(weatherWidgetViewModel)
      })
      .disposed(by: self.disposeBag)
    
    let weatherComponentsSubject: PublishRelay<[WeatherComponentCollectionCellViewModel]> = .init()
    weatherGeneralResponse
      .compactMap { weatherGeneralResponse in
        return WeatherDetailAppModel(dayDate: .now, weatherDetailResponses: weatherGeneralResponse.weathers)?.weatherDetailResponses
      }
      .map { [weak self] weatherDetailResponses -> [WeatherComponentCollectionCellViewModel] in
        guard let self = self else {
          return []
        }
        return weatherDetailResponses.map { weatherDetailResponse in
          return WeatherComponentCollectionCellViewModel(weatherDetailResponse: weatherDetailResponse, weatherService: self.weatherService)
        }
      }
      .subscribe(onNext: { weatherComponentCollectionCellViewModels in
        weatherComponentsSubject.accept(weatherComponentCollectionCellViewModels)
      })
      .disposed(by: self.disposeBag)
    
    Observable
      .combineLatest(input.selectWeatherDay.asObservable(), weatherGeneralResponse)
      .compactMap({ (weatherDayTableCellViewModel, weatherGeneralResponse) in
        return WeatherDetailAppModel(dayDate: weatherDayTableCellViewModel.weatherDetailAppModel.dayDate, weatherDetailResponses: weatherGeneralResponse.weathers)?.weatherDetailResponses
      })
      .map { [weak self] weatherDetailResponses -> [WeatherComponentCollectionCellViewModel] in
        guard let self = self else {
          return []
        }
        return weatherDetailResponses.map { weatherDetailResponse in
          return WeatherComponentCollectionCellViewModel(weatherDetailResponse: weatherDetailResponse, weatherService: self.weatherService)
        }
      }
      .subscribe(onNext: { weatherComponentCollectionCellViewModels in
        weatherComponentsSubject.accept(weatherComponentCollectionCellViewModels)
      })
      .disposed(by: self.disposeBag)
    
    Observable
      .combineLatest(input.selectWeatherDay.asObservable(), weatherGeneralResponse)
      .compactMap { weatherDayTableCellViewModel, weatherGeneralResponse in
        return WeatherDetailAppModel(dayDate: weatherDayTableCellViewModel.weatherDetailAppModel.dayDate, weatherDetailResponses: weatherGeneralResponse.weathers)
      }
      .compactMap { [weak self] weatherDetailAppModel -> WeatherWidgetViewModel? in
        guard let self = self else {
          return nil
        }
        return WeatherWidgetViewModel(weatherDetailAppModel: weatherDetailAppModel, weatherService: self.weatherService)
      }
      .subscribe(onNext: { weatherWidgetViewModel in
        weatherWidgetViewModelSubject.accept(weatherWidgetViewModel)
      })
      .disposed(by: self.disposeBag)
    
    let weatherDayViewModel = weatherGeneralResponse
      .map { weatherGeneralResponse -> [WeatherDetailAppModel] in
        return WeatherDetailAppModel.seperateWeatherDetailResponsesByDay(weatherDetailResponses: weatherGeneralResponse.weathers)
      }
      .compactMap { [weak self] weatherDetailAppModels -> [WeatherDayTableCellViewModel]? in
        guard let self = self else {
          return nil
        }
        return weatherDetailAppModels.map { weatherDetailAppModel in
          WeatherDayTableCellViewModel(weatherDetailAppModel: weatherDetailAppModel, weatherService: self.weatherService)
        }
      }
    return Output(
      weatherWidgetViewModel: weatherWidgetViewModelSubject.asDriver(onErrorRecover: { error in
        return Driver.empty()
      }),
      weatherComponents: weatherComponentsSubject.asDriver(onErrorJustReturn: []),
      weatherDayViewModel: weatherDayViewModel.asDriver(onErrorJustReturn: []),
      titleDriver: citySubject.asDriver(onErrorJustReturn: "")
    )
  }
  
  struct Input {
    let loadWeatherDataTrigger: PublishRelay<Void>
    let selectWeatherDay: Driver<WeatherDayTableCellViewModel>
    let findCityTrigger: Driver<Void>
    let findLocationTrigger: Driver<Void>
  }
  
  struct Output {
    let weatherWidgetViewModel: Driver<WeatherWidgetViewModel>
    let weatherComponents: Driver<[WeatherComponentCollectionCellViewModel]>
    let weatherDayViewModel: Driver<[WeatherDayTableCellViewModel]>
    let titleDriver: Driver<String>
  }
}
