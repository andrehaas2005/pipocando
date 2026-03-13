//
//  SceneDelegate.swift
//  Pipocando
//
//  Created by Andre  Haas on 11/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    let navigationController = NavigationController()

    let networkMovieService = NetworkMovieService()
    let networkSerieService = NetworkSerieService()
    let movieService = MovieService(service: networkMovieService)
    let serieService = SerieService(service: networkSerieService)

    let dependencies = AppDependencyContainer(
      movieService: movieService,
      serieService: serieService
    )

    appCoordinator = AppCoordinator(navigationController: navigationController, dependencies: dependencies)
    appCoordinator?.start()
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
  }

  func sceneWillResignActive(_ scene: UIScene) {
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
  }


}

