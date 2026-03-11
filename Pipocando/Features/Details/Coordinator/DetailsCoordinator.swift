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

  private let movieService: any MovieServiceProtocol

  init(
    navigationController: NavigationController,
    movieService: any MovieServiceProtocol = MovieService.shared
  ) {
    self.navigationController = navigationController
    self.movieService = movieService
  }

  func start(with detailType: DetailType) {
    let viewModel = DetailsViewModel(
      detailType: detailType,
      movieService: movieService
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
