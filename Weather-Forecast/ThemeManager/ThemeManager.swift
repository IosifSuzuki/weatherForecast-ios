//
//  ThemeManager.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 10.11.2022.
//

import UIKit

class ThemeManager: Theme {
  
  var backgroundColor: UIColor {
    return .init(hex: "#4A90E2")!
  }
  
  var primaryColor: UIColor {
    return .init(hex: "#5A9FF0")!
  }
  
  var textColorOnDarkBackground: UIColor {
    return .init(hex: "#FFFFFF")!
  }
  
  var textColorOnWhiteBakgorund: UIColor {
    return .init(hex: "#000000")!
  }
  
  func appFont(by size: CGFloat, weight: FontWeight) -> UIFont {
    switch weight {
    case .bold:
      return .systemFont(ofSize: size, weight: .bold)
    case .regular:
      return .systemFont(ofSize: size, weight: .regular)
    case .thin:
      return .systemFont(ofSize: size, weight: .thin)
    }
  }
  
  var highlightGradient: CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.colors = [
      UIColor(hex: "#FFFFFF")!,
      UIColor(hex: "#5A9FF0")!,
    ]
    gradient.opacity = 1
    return gradient
  }
  
}

