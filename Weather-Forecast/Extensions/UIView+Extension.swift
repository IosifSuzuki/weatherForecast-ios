//
//  UIView+Extension.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 14.11.2022.
//

import UIKit

extension UIView {
  
  func addShadow(color: UIColor) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 2.0
    layer.shadowOffset = .zero
    layer.masksToBounds = false
    
  }
  
}
