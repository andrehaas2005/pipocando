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
    let homeUseCase = dependencies.makeFetchNowPlayingMoviesUseCase()
    let posterUseCase = dependencies.makeFetchNowPlayingMoviesUseCase()
    let carrosselUseCase = dependencies.makeFetchNowPlayingMoviesUseCase()

    let homeViewModel = HomeViewModel(fetchNowPlayingMoviesUseCase: homeUseCase)
    let posterViewModel = PosterViewModel(fetchNowPlayingMoviesUseCase: posterUseCase)
    let carrosselViewModel = CarrosselViewModel(fetchNowPlayingMoviesUseCase: carrosselUseCase)

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
