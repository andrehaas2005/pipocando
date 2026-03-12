//
//  HomeCoordinator.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import UIKit

class HomeCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: NavigationController
  weak var parentCoordinator: AppCoordinator?

  private let dependencies: AppDependencies

  init(
    navigationController: NavigationController,
    dependencies: AppDependencies
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    let homeViewModel = HomeViewModel(fetchNowPlayingMoviesUseCase: dependencies.makeFetchNowPlayingMoviesUseCase())
    let posterViewModel = PosterViewModel(movieService: dependencies.movieService)
    let carrosselViewModel = CarrosselViewModel(movieService: dependencies.movieService)

    let homeViewController = HomeViewController(
      viewModel: homeViewModel,
      posterViewModel: posterViewModel,
      carrosselViewModel: carrosselViewModel
    )

    homeViewModel.coordinator = self
    homeViewController.delegate = self
    navigationController.setViewControllers([homeViewController], animated: true)
  }

  func showMovieDetails(_ movie: Movie) {
    let detailsCoordinator = DetailsCoordinator(
      navigationController: navigationController,
      fetchMovieDetailsUseCase: dependencies.makeFetchMovieDetailsUseCase()
    )
    detailsCoordinator.parentCoordinator = self
    addChild(detailsCoordinator)
    detailsCoordinator.start(with: .movie(movie))
  }

  func childDidFinish(_ coordinator: Coordinator) {
    removeChild(coordinator)
  }
}

extension HomeCoordinator: HomeViewControllerDelegate {
  func didSelectMovie(_ movie: Movie) {
    showMovieDetails(movie)
  }

  func didRequestLogout() {}
}


extension HomeCoordinator: HomeRouting {}
