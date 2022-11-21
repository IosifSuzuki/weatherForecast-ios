//
//  WeatherWidgetView.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

protocol WeatherWidgetRepresentable: AnyObject {
  var dateTextRepresentable: String? { get }
  var temperatureTextRepresentable: String? { get }
  var humidityTextRepresentable: String { get }
  var windSpeedTextRepresentable: String? { get }
  var weatherIconURL: URL? { get }
  var windDirection: WindDirection? { get }
}

class WeatherWidgetView: UIView, ThemeDependency {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var temparatureIconImageView: UIImageView!
  @IBOutlet weak var temperatureValueLabel: UILabel!
  @IBOutlet weak var humidityValueLabel: UILabel!
  @IBOutlet weak var humidityImageView: UIImageView!
  @IBOutlet weak var windImageView: UIImageView!
  @IBOutlet weak var windValueLabel: UILabel!
  @IBOutlet weak var windDirectionImageView: UIImageView!
  
  var viewModel: WeatherWidgetRepresentable?
  
  // MARK: - Initializations
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    commonInit()
  }
  
  // MARK: - ThemeDependency
  
  func apply(theme: Theme) {
    dateLabel.textColor = theme.textColorOnDarkBackground
    dateLabel.font = theme.appFont(by: 16, weight: .thin)
    temperatureValueLabel.textColor = theme.textColorOnDarkBackground
    temperatureValueLabel.font = theme.appFont(by: 18, weight: .regular)
    humidityValueLabel.textColor = theme.textColorOnDarkBackground
    humidityValueLabel.font = theme.appFont(by: 18, weight: .regular)
    windValueLabel.textColor = theme.textColorOnDarkBackground
    windValueLabel.font = theme.appFont(by: 18, weight: .regular)
    weatherIconImageView.tintColor = theme.textColorOnDarkBackground
    temparatureIconImageView.tintColor = theme.textColorOnDarkBackground
    humidityImageView.tintColor = theme.textColorOnDarkBackground
    windImageView.tintColor = theme.textColorOnDarkBackground
    windDirectionImageView.tintColor = theme.textColorOnDarkBackground
  }
  
  // MARK: - Public Methods
  
  func setup(viewModel: WeatherWidgetViewModel) {
    self.viewModel = viewModel
    self.dateLabel.text = viewModel.dateTextRepresentable
    self.temperatureValueLabel.text = viewModel.temperatureTextRepresentable
    self.humidityValueLabel.text = viewModel.humidityTextRepresentable
    self.windValueLabel.text = viewModel.windSpeedTextRepresentable
    self.windDirectionImageView.image = viewModel.windDirection?.arrowImageView
    if let weatherIconURL = viewModel.weatherIconURL {
      self.weatherIconImageView.kf.setImage(
        with: weatherIconURL,
        placeholder: UIImage(systemName: "cloud.sun.fill"),
        options: [
          .scaleFactor(UIScreen.main.scale),
          .transition(.fade(2)),
          .cacheOriginalImage
        ],
        completionHandler: { [weak self] result in
          guard let self = self else {
            return
          }
          self.weatherIconImageView.image = self.weatherIconImageView.image?.withRenderingMode(.alwaysTemplate)
        }
      )
    }
  }
  
  // MARK: - Private Methods
  
  func commonInit() {
    Bundle.main.loadNibNamed("\(WeatherWidgetView.self)", owner: self, options: nil)
    translatesAutoresizingMaskIntoConstraints = false
    frame = containerView.bounds
    addSubview(containerView)
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      topAnchor.constraint(equalTo: containerView.topAnchor),
      trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])
  }
}
