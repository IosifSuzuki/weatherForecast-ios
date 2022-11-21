//
//  CityTableViewCell.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  var viewModel: CityTableViewModel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setup(viewModel: CityTableViewModel) {
    self.viewModel = viewModel
    self.titleLabel.text = "\(viewModel.city), \(viewModel.country)"
  }
  
  func apply(theme: Theme) {
    self.titleLabel.textColor = theme.textColorOnWhiteBakgorund
  }
  
}
