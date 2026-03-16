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
  private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
  private let movieService: any MovieServiceProtocol

  init(
    navigationController: NavigationController,
    serieService: any SerieServiceProtocol,
    fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase,
    movieService: any MovieServiceProtocol
  ) {
    self.navigationController = navigationController
    self.serieService = serieService
    self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    self.movieService = movieService
  }

  func start() {
    let viewModel = CalendarViewModel(coordinator: self, serieService: serieService)
    let viewController = CalendarViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}


extension CalendarCoordinator: CalendarRouting {
  func showSerieDetails(_ serie: Serie) {
    let detailsCoordinator = DetailsCoordinator(
      navigationController: navigationController,
      fetchMovieDetailsUseCase: fetchMovieDetailsUseCase,
      movieService: movieService
    )
    detailsCoordinator.start(with: .serie(serie))
  }
}
