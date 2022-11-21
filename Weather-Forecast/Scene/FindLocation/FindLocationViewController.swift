//
//  FindLocationViewController.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 17.11.2022.
//

import UIKit
import RxSwift
import MapKit

class FindLocationViewController: BaseViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  lazy var doneBarButtonItem: UIBarButtonItem = {
    return .init(systemItem: .done)
  }()
  
  var viewModel: FindLocationViewModel!
  var lastCoordinate: CLLocationCoordinate2D?
  var pinLocationSubject: PublishSubject<CLLocationCoordinate2D> = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    setupView()
  }
  
  override func apply(theme: Theme) {
    super.apply(theme: theme)
    
    navigationController?.navigationBar.tintColor = theme.textColorOnDarkBackground
  }
  
  // MARK: - Actions
  
  @IBAction func didTapOnMap(_ gesture: UITapGestureRecognizer) {
    let point = gesture.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    self.lastCoordinate = coordinate
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    self.pinLocationSubject.on(.next(coordinate))
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(annotation)
  }
  
  //MARK: - Private Methods
  
  private func bindViewModel() {
    let selectLocationTrigger = doneBarButtonItem.rx.tap.compactMap { [weak self] _ -> CLLocationCoordinate2D? in
      guard let self = self else {
        return nil
      }
      return self.lastCoordinate
    }
    let input = FindLocationViewModel.Input(
      didPinLocation: self.pinLocationSubject,
      selectedLocation: selectLocationTrigger.asObservable()
    )
    let output = viewModel.transform(input: input)
    output.enableNextStep
      .drive(doneBarButtonItem.rx.isEnabled)
      .disposed(by: bag)
    
    output.userLocation
      .drive { [weak self] coordinate in
      guard let self = self else {
        return
      }
      self.lastCoordinate = coordinate
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      self.mapView.addAnnotation(annotation)
    }.disposed(by: bag)
  }
  
  private func setupView() {
    navigationItem.rightBarButtonItem = doneBarButtonItem
    mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(MKMarkerAnnotationView.self)")
  }
}

extension FindLocationViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "\(MKMarkerAnnotationView.self)")
    annotationView.markerTintColor = theme.primaryColor
    return annotationView
  }
  
}
