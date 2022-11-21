//
//  FindCityViewController.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 16.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

class FindCityViewController: BaseViewController {
  @IBOutlet weak var tableView: UITableView!
  
  lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchTextField.leftView = UIImageView()
    searchBar.searchTextField.borderStyle = .roundedRect
    searchBar.searchTextField.leftViewMode = .never
    searchBar.searchTextField.rightViewMode = .always
    return searchBar
  }()
  
  lazy var rightBarButtonItem: UIBarButtonItem = {
    return .init(
      image: UIImage(systemName: "magnifyingglass"),
      style: .plain,
      target: nil,
      action: nil
    )
  }()
  
  var viewModel: FindCityViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    bindViewModel()
  }
  
  override func apply(theme: Theme) {
    super.apply(theme: theme)
    
    searchBar.searchTextField.backgroundColor = theme.textColorOnDarkBackground
    searchBar.searchTextField.textColor = theme.textColorOnWhiteBakgorund
    searchBar.searchTextField.rightViewMode = .never
    navigationController?.navigationBar.tintColor = theme.textColorOnDarkBackground
    searchBar.searchTextField.tintColor = theme.primaryColor
    searchBar.searchTextField.textColor = theme.textColorOnWhiteBakgorund
    searchBar.searchTextField.attributedPlaceholder = .init(string: "Search city", attributes: [
      NSAttributedString.Key.foregroundColor: UIColor.gray,
    ])
  }
  
  // MARK: - Private Methods
  
  private func bindViewModel() {
    let searchTextDidChanged = searchBar
      .rx
      .text
      .orEmpty
      .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.asyncInstance)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: "")
    let selectItemTrigger = tableView.rx.itemSelected.compactMap { [weak self] indexPath -> CityTableViewModel? in
      guard let self = self, let cell = self.tableView.cellForRow(at: indexPath) as? CityTableViewCell else {
        return nil
      }
      return cell.viewModel
    }.map{ cityTableViewModel in
      return LocationAppModel(city: cityTableViewModel.city, country: cityTableViewModel.country)
    }
    .asDriver(onErrorJustReturn: .init(city: "", country: ""))
    let input: FindCityViewModel.Input = .init(searchTextTrigger: searchTextDidChanged, selectLocationTrigger: selectItemTrigger)
    let output = viewModel.transform(input: input)
    output.dataSourceDidChanged
      .drive(tableView.rx.items(cellIdentifier: "\(CityTableViewCell.self)")) { [weak self] idx, cellViewModel, cell in
        guard let self = self, let cell = cell as? CityTableViewCell else {
          return
        }
        cell.setup(viewModel: cellViewModel)
        cell.apply(theme: self.theme)
      }
      .disposed(by: bag)
    rightBarButtonItem.rx.tap.subscribe { [weak self]  _ in
      guard let self = self else {
        return
      }
      if self.navigationItem.titleView == nil {
        self.navigationItem.titleView = self.searchBar
      } else {
        self.navigationItem.titleView = nil
      }
    }
    .disposed(by: self.bag)
  }
  
  private func setupView() {
    navigationItem.rightBarButtonItem = self.rightBarButtonItem
    searchBar.sizeToFit()
    let tableCellNib = UINib(nibName: "\(CityTableViewCell.self)", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "\(CityTableViewCell.self)")
    tableView.separatorInset = .zero
    tableView.rowHeight = 50
  }
  
}
