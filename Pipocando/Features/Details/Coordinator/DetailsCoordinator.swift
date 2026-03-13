//
//  DetailType.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

import UIKit

enum DetailType {
  case movie(Movie)
  case serie(Serie)
  case actor(Actor)
}

class DetailsCoordinator: Coordinator {
  weak var parentCoordinator: HomeCoordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: NavigationController

  private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase

  init(
    navigationController: NavigationController,
    fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase
  ) {
    self.navigationController = navigationController
    self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
  }

  func start(with detailType: DetailType) {
    let viewModel = DetailsViewModel(
      detailType: detailType,
      fetchMovieDetailsUseCase: fetchMovieDetailsUseCase
    )
    viewModel.coordinator = self

    let viewController = DetailsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }

  func didFinishDetails() {
    parentCoordinator?.childDidFinish(self)
  }

  func start() {}
}


extension DetailsCoordinator: DetailsRouting {}
