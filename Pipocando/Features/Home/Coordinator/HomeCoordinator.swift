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

  private let movieService: any MovieServiceProtocol

  init(
    navigationController: NavigationController,
    movieService: any MovieServiceProtocol = MovieService.shared
  ) {
    self.navigationController = navigationController
    self.movieService = movieService
  }

  func start() {
    let repository = MoviesRepositoryImpl(movieService: movieService)
    let useCase = DefaultFetchNowPlayingMoviesUseCase(repository: repository)
    let homeViewModel = HomeViewModel(fetchNowPlayingMoviesUseCase: useCase)
    let posterViewModel = PosterViewModel(movieService: movieService)
    let carrosselViewModel = CarrosselViewModel(movieService: movieService)

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
      movieService: movieService
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
