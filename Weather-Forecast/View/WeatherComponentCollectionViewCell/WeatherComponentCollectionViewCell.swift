//
//  WeatherComponentCollectionCellView.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import UIKit
import Kingfisher

protocol WeatherComponentCollectionCellViewModelRepresentable {
  var hourTextRepresentable: String { get }
  var minuteTextRepresentable: String { get }
  var weatherIconURL: URL? { get }
  var temperatureTextRepresentable: String { get }
}

class WeatherComponentCollectionCellView: UICollectionViewCell, ThemeDependency {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  var viewModel: WeatherComponentCollectionCellViewModelRepresentable!
  
  // MARK: - Life cycles
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.weatherIconImageView.kf.cancelDownloadTask()
  }
  
  // MARK: - ThemeDependency
  
  func apply(theme: Theme) {
    self.timeLabel.textColor = theme.textColorOnDarkBackground
    self.temperatureLabel.textColor = theme.textColorOnDarkBackground
    self.weatherIconImageView.tintColor = theme.textColorOnDarkBackground
  }
  
  // MARK: - Public Methods
  
  func setup(viewModel: WeatherComponentCollectionCellViewModelRepresentable) {
    self.viewModel = viewModel
    let textFont = UIFont.systemFont(ofSize: 14)
    let superscriptFont = UIFont.systemFont(ofSize: 10)
    let timeText = "\(viewModel.hourTextRepresentable)\(viewModel.minuteTextRepresentable)"
    let timeAttributedString: NSMutableAttributedString = .init(
      string: timeText,
      attributes: [.font: textFont]
    )
    timeAttributedString.addAttributes([
      .font: superscriptFont,
      .baselineOffset: 6,
    ], range: (timeText as NSString).range(of: viewModel.minuteTextRepresentable, options: .backwards))
    timeLabel.attributedText = timeAttributedString
    timeLabel.textAlignment = .center
    if let weatherIconURL = viewModel.weatherIconURL {
      self.weatherIconImageView.kf.setImage(
        with: weatherIconURL,
        placeholder: UIImage(systemName: "cloud.sun.fill"),
        options: [
          .scaleFactor(UIScreen.main.scale),
          .transition(.fade(2)),
          .cacheMemoryOnly
        ],
        completionHandler: { [weak self] result in
          guard let self = self else {
            return
          }
          self.weatherIconImageView.image = self.weatherIconImageView.image?.withRenderingMode(.alwaysTemplate)
        }
      )
    }
    temperatureLabel.text = viewModel.temperatureTextRepresentable
  }
}
