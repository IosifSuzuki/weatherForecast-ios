//
//  WeatherDayTableCellViewTableViewCell.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import UIKit

protocol WeatherDayTableCellViewModelRepresentable {
  var dayTextRepresentable: String { get }
  var temperatureTextRepresentable: String? { get }
  var weatherIconPath: URL? { get }
}

class WeatherDayTableCellView: UITableViewCell, ThemeDependency {
  
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  
  var highlightGradient: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [
      UIColor(hex: "#FFFFFF")!.cgColor,
      UIColor(hex: "#5A9FF0")!.cgColor,
    ]
    gradient.opacity = 0.05
    return gradient
  }()
  
  var theme: Theme!
  
  var activeColor: UIColor? {
    return theme.primaryColor
  }
  
  var unactiveColor: UIColor? {
    return theme.textColorOnWhiteBakgorund
  }
  
  var viewModel: WeatherDayTableCellViewModel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.selectionStyle = .none
    self.selectedView.layer.addSublayer(highlightGradient)
    self.highlightGradient.frame = self.selectedView.bounds
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.weatherIconImageView.kf.cancelDownloadTask()
    self.selectedView.isHidden = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    highlightGradient.frame = bounds
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    selectedView.isHidden = !selected
    layer.shadowOpacity = selected ? 0.5 : 0
    layer.zPosition = selected ? 1 : 0
    dayLabel.textColor = selected ? activeColor : unactiveColor
    temperatureLabel.textColor = selected ? activeColor : unactiveColor
    weatherIconImageView.tintColor = selected ? activeColor : unactiveColor
  }
  
  // MARK: - ThemeDependency
  
  func apply(theme: Theme) {
    self.theme = theme
    backgroundColor = theme.textColorOnDarkBackground
    dayLabel.textColor = theme.textColorOnWhiteBakgorund
    temperatureLabel.textColor = theme.textColorOnWhiteBakgorund
    weatherIconImageView.tintColor = theme.textColorOnWhiteBakgorund
    addShadow(color: theme.primaryColor)
  }
  
  func setup(viewModel: WeatherDayTableCellViewModel) {
    self.layer.masksToBounds = false
    self.contentView.layer.masksToBounds = false
    self.selectedView.layer.masksToBounds = false
    self.dayLabel.text = viewModel.dayTextRepresentable
    self.temperatureLabel.text = viewModel.temperatureTextRepresentable
    self.viewModel = viewModel
    if let weatherIconURL = viewModel.weatherIconPath {
      self.weatherIconImageView.kf.setImage(
        with: weatherIconURL,
        placeholder: UIImage(systemName: "cloud.sun.fill"),
        options: [
          .scaleFactor(UIScreen.main.scale),
          .transition(.fade(0.5)),
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
  }
  
}
