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
  private let serieService: any SerieServiceProtocol

  init(
    navigationController: NavigationController,
    serieService: any SerieServiceProtocol
  ) {
    self.navigationController = navigationController
    self.serieService = serieService
  }

  func start() {
    let repository = SeriesRepositoryImpl(serieService: serieService)
    let useCase = DefaultFetchTopRatedSeriesUseCase(repository: repository)
    let viewModel = CalendarViewModel(coordinator: self, fetchTopRatedSeriesUseCase: useCase)
    let viewController = CalendarViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}
