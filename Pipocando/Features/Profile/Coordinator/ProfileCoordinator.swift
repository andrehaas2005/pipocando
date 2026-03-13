import UIKit

final class ProfileCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: NavigationController

  init(navigationController: NavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = ProfileViewModel()
    viewModel.coordinator = self
    let viewController = ProfileViewController(viewModel: viewModel)
    navigationController.setViewControllers([viewController], animated: false)
  }
}

extension ProfileCoordinator: ProfileRouting {
  func didRequestLogout() {
    AppLogger.debug("Logout solicitado no profile", category: .navigation)
  }
}
