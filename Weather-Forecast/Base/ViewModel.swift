//
//  ViewModel.swift
//  Weather-Forecast
//
//  Created by Bogdan Petkanitch on 13.11.2022.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype CoordinatorType: BaseCoordinator

    var coordinator: CoordinatorType { get }

    func transform(input: Input) -> Output
}
