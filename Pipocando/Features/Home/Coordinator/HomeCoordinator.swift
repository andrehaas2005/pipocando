//
//  HomeCoordinator.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import UIKit

class HomeCoordinator: Coordinator {
  var childCoordinators: [any Coordinator] = []
  
  var navigationController: NavigationController
  
  weak var parentCoordinator: AppCoordinator?
  
  
  
  init(navigationController: NavigationController){
    self.navigationController = navigationController
  }
  
  func start() {
    let movieService = MovieService()
    let homeViewModel = HomeViewModel(service: movieService)
    let homeViewController = HomeViewController(viewModel: homeViewModel)
    homeViewModel.coordinator = self
    homeViewController.delegate = self
    navigationController.setViewControllers([homeViewController], animated: true)
  }
  
  private func showMovieDetails(_ movie: Movie) {
    // Cria e inicia um DetailsCoordinator para gerenciar o fluxo de detalhes.
    let detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
    detailsCoordinator.parentCoordinator = self // Define o HomeCoordinator como pai
    childCoordinators.append(detailsCoordinator)
    detailsCoordinator.start(with: .movie(movie))
  }
  
  func childDidFinish(_ corrd: Coordinator) {
    
  }
}

extension HomeCoordinator: HomeViewControllerDelegate {
  func didSelectMovie(_ movie: Movie) {
    showMovieDetails(movie)
  }
  
  func didRequestLogout() {
    
  }
  
  
}
