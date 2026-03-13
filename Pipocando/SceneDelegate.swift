import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    let navigationController = NavigationController()

    let sharedSession = AlamofireSessionProvider.makeSession()
    let networkMovieService = NetworkMovieService(session: sharedSession)
    let networkSerieService = NetworkSerieService(session: sharedSession)
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
}
