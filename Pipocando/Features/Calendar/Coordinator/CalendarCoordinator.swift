//
//  CalendarCoordinator.swift
//  AmorPorFilmesSeries
//
//  Created by Jules on 05/06/25.
//

import UIKit

class CalendarCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: NavigationController
  private let fetchTopRatedSeriesUseCase: any FetchTopRatedSeriesUseCase

  init(
    navigationController: NavigationController,
    fetchTopRatedSeriesUseCase: any FetchTopRatedSeriesUseCase
  ) {
    self.navigationController = navigationController
    self.fetchTopRatedSeriesUseCase = fetchTopRatedSeriesUseCase
  }

  func start() {
    let viewModel = CalendarViewModel(coordinator: self, fetchTopRatedSeriesUseCase: fetchTopRatedSeriesUseCase)
    let viewController = CalendarViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}


extension CalendarCoordinator: CalendarRouting {}
