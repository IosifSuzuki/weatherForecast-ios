//
//  WeatherViewController.swift
//  Weather Forecast
//
//  Created by Bogdan Petkanitch on 09.11.2022.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: BaseViewController {
  
  //Outlets
  @IBOutlet weak var weatherWidgetView: WeatherWidgetView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  
  lazy var locationBarButtonItem: LocationCityBarButtonItem = {
    return LocationCityBarButtonItem(titleCity: "Uzhgorod")
  }()
  
  lazy var rightBarButtonItem: UIBarButtonItem = {
    let rightImage = UIImage(
      systemName: "smallcircle.fill.circle",
      withConfiguration: UIImage.SymbolConfiguration(scale: .medium)
    )
    return UIBarButtonItem(image: rightImage, style: .plain, target: nil, action: nil)
  }()
  
  var viewModel: WeatherViewModel!
  
  // MARK: - Life Cycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    bindViewModel()
  }
  
  override func apply(theme: Theme) {
    super.apply(theme: theme)
    collectionView.backgroundColor = theme.primaryColor
    tableView.backgroundColor = theme.textColorOnDarkBackground
    weatherWidgetView.apply(theme: theme)
    locationBarButtonItem.apply(theme: theme)
    rightBarButtonItem.tintColor = theme.textColorOnDarkBackground
  }
  
  // MARK: - Private Methods
  
  private func bindViewModel() {
    let loadWeatherDataTrigger: PublishRelay<Void> = .init()
    let itemCellSelected = tableView.rx.itemSelected.compactMap { [weak self] indexPath -> WeatherDayTableCellViewModel? in
      guard let self = self, let cell = self.tableView.cellForRow(at: indexPath) as? WeatherDayTableCellView else {
        return nil
      }
      return cell.viewModel
    }.asDriver { error in
      return Driver.empty()
    }
    let input: WeatherViewModel.Input = .init(
      loadWeatherDataTrigger: loadWeatherDataTrigger,
      selectWeatherDay: itemCellSelected,
      findCityTrigger: self.rightBarButtonItem.rx.tap.asDriver(),
      findLocationTrigger: self.locationBarButtonItem.tap
    )
    let output = viewModel.transform(input: input)
    output.weatherWidgetViewModel
      .drive { [weak self] weatherWidgetViewModel in
        guard let self = self else {
          return
        }
        self.weatherWidgetView.setup(viewModel: weatherWidgetViewModel)
      }
      .disposed(by: self.bag)
    output.weatherComponents
      .drive(collectionView.rx.items(cellIdentifier: "\(WeatherComponentCollectionCellView.self)")) {_, cellViewModel, cell in
        guard let cell = cell as? WeatherComponentCollectionCellView else {
          return
        }
        cell.setup(viewModel: cellViewModel)
        cell.apply(theme: self.theme)
      }
      .disposed(by: bag)
    output.weatherDayViewModel
      .drive(tableView.rx.items(cellIdentifier: "\(WeatherDayTableCellView.self)")) { [weak self] idx, cellViewModel, cell in
        guard let self = self, let cell = cell as? WeatherDayTableCellView else {
          return
        }
        cell.setup(viewModel: cellViewModel)
        cell.apply(theme: self.theme)
        if idx == 0 {
          self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
      }
      .disposed(by: bag)
    output.titleDriver
      .drive(onNext: { [weak self] city in
        self?.locationBarButtonItem.titleCity = city
        loadWeatherDataTrigger.accept(())
      })
      .disposed(by: bag)
    loadWeatherDataTrigger.accept(())
  }
  
  private func setupView() {
    let collectionCellNib = UINib(nibName: "\(WeatherComponentCollectionCellView.self)", bundle: Bundle.main)
    collectionView.register(collectionCellNib, forCellWithReuseIdentifier: "\(WeatherComponentCollectionCellView.self)")
    collectionView.collectionViewLayout.invalidateLayout()
    collectionView.collectionViewLayout = createListCollectionLayout()
    collectionView.alwaysBounceVertical = false
    
    let tableCellNib = UINib(nibName: "\(WeatherDayTableCellView.self)", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "\(WeatherDayTableCellView.self)")
    tableView.separatorStyle = .none
    tableView.rowHeight = 50
    navigationItem.leftBarButtonItem = locationBarButtonItem
    navigationItem.rightBarButtonItem = rightBarButtonItem
  }
  
  private func createListCollectionLayout() -> UICollectionViewLayout {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalHeight(0.5),
        heightDimension: .fractionalHeight(1)
      )
      let item = NSCollectionLayoutItem(
        layoutSize: itemSize
      )
    
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
      )
    
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      let layout = UICollectionViewCompositionalLayout(section: section)
      
      layout.configuration.scrollDirection = .horizontal
      return layout
  }
  
}
