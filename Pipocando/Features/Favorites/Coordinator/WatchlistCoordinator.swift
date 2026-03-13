import UIKit

final class WatchlistCoordinator: Coordinator {
  var navigationController: NavigationController
  var childCoordinators = [Coordinator]()

  init(navigationController: NavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let watchlistViewModel = WatchlistViewModel(coordinator: self)
    let watchlistViewController = WatchlistViewController(viewModel: watchlistViewModel)
    navigationController.setViewControllers([watchlistViewController], animated: false)
  }
}

extension WatchlistCoordinator: WatchlistRouting {
  func showWatchedHistory() {
    AppLogger.debug("Histórico solicitado na watchlist", category: .navigation)
  }
}
