//
//  BaseViewController.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, ThemeDependency {
  let bag: DisposeBag = DisposeBag()
  var theme: Theme!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
      return .darkContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.apply(theme: theme)
  }
  
  // MARK: - ThemeDependency
  
  func apply(theme: Theme) {
    self.view.backgroundColor = theme.backgroundColor
  }
  
}
