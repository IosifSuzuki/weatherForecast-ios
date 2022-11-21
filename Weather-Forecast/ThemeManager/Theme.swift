//
//  Theme.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import UIKit

protocol ThemeDependency {
  func apply(theme: Theme)
}

enum FontWeight {
  case thin
  case regular
  case bold
  
}

protocol Theme {
  var backgroundColor: UIColor { get }
  var primaryColor: UIColor { get }
  var textColorOnDarkBackground: UIColor { get }
  var textColorOnWhiteBakgorund: UIColor { get }
  var highlightGradient: CAGradientLayer { get }
  
  func appFont(by size: CGFloat, weight: FontWeight) -> UIFont
}
