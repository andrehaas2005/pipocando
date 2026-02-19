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
    navigationController.setViewControllers([homeViewController], animated: true)
  }
  func childDidFinish(_ corrd: Coordinator) {
    
  }
}
