//
//  AppCoordinator.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import UIKit

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: NavigationController { get set }

  func start()
}

extension Coordinator {
  func addChild(_ coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }

  func removeChild(_ coordinator: Coordinator) {
    childCoordinators.removeAll { $0 === coordinator }
  }
}

class AppCoordinator: Coordinator {
  var navigationController: NavigationController
  var childCoordinators: [Coordinator] = []
  private let dependencies: AppDependencies

  init(
    navigationController: NavigationController,
    dependencies: AppDependencies = AppDependencyContainer()
  ) {
    self.navigationController = navigationController
    self.dependencies = dependencies
  }

  func start() {
    showMainTabBarFlow()
  }

  func showMainTabBarFlow() {
    navigationController.viewControllers = []
    childCoordinators.removeAll()

    let tabBarController = UITabBarController()
    tabBarController.tabBar.tintColor = Color.primary
    tabBarController.tabBar.barTintColor = Color.backgroundDark
    tabBarController.tabBar.backgroundColor = Color.backgroundDark
    tabBarController.tabBar.isTranslucent = true

    // 1. Home
    let homeNavController = NavigationController()
    let homeCoordinator = HomeCoordinator(
      navigationController: homeNavController,
      movieService: dependencies.movieService
    )
    addChild(homeCoordinator)
    homeCoordinator.start()
    homeNavController.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), tag: 0)
    homeNavController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")

    // 2. Explore (Placeholder)
    let exploreNavController = NavigationController()
    let exploreVC = UIViewController()
    exploreVC.view.backgroundColor = Color.backgroundDark
    exploreVC.title = "Explorar"
    exploreNavController.setViewControllers([exploreVC], animated: false)
    exploreNavController.tabBarItem = UITabBarItem(title: "Explorar", image: UIImage(systemName: "magnifyingglass"), tag: 1)

    // 3. My List
    let watchlistNavController = NavigationController()
    let watchlistCoordinator = WatchlistCoordinator(navigationController: watchlistNavController)
    addChild(watchlistCoordinator)
    watchlistCoordinator.start()
    watchlistNavController.tabBarItem = UITabBarItem(title: "Minha Lista", image: UIImage(systemName: "bookmark"), tag: 2)
    watchlistNavController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")

    // 4. Calendar
    let calendarNavController = NavigationController()
    let calendarCoordinator = CalendarCoordinator(
      navigationController: calendarNavController,
      serieService: dependencies.serieService
    )
    addChild(calendarCoordinator)
    calendarCoordinator.start()
    calendarNavController.tabBarItem = UITabBarItem(title: "Calendário", image: UIImage(systemName: "calendar"), tag: 3)
    calendarNavController.tabBarItem.selectedImage = UIImage(systemName: "calendar.badge.clock")

    // 5. Profile
    let profileNavController = NavigationController()
    let profileVC = ProfileViewController()
    profileNavController.setViewControllers([profileVC], animated: false)
    profileNavController.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), tag: 4)
    profileNavController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

    tabBarController.viewControllers = [
      homeNavController,
      exploreNavController,
      watchlistNavController,
      calendarNavController,
      profileNavController
    ]
    navigationController.setViewControllers([tabBarController], animated: true)
  }
}
