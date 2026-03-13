import Foundation

protocol ProfileRouting: AnyObject {
  func didRequestLogout()
}

struct ProfileMenuItem {
  let title: String
  let icon: String
  let isDestructive: Bool
}

enum ProfileState {
  case idle
  case loading
  case loaded(name: String, email: String, options: [ProfileMenuItem])
  case error(AppError)
}

@MainActor
final class ProfileViewModel {
  weak var coordinator: (any ProfileRouting)?
  let screenState = Observable<ProfileState>(.idle)

  func fetchData() {
    screenState.value = .loading

    let options = [
      ProfileMenuItem(title: "Editar Perfil", icon: "person", isDestructive: false),
      ProfileMenuItem(title: "Notificações", icon: "bell", isDestructive: false),
      ProfileMenuItem(title: "Privacidade", icon: "lock", isDestructive: false),
      ProfileMenuItem(title: "Ajuda & Suporte", icon: "questionmark.circle", isDestructive: false),
      ProfileMenuItem(title: "Sair", icon: "arrow.right.square", isDestructive: true)
    ]

    screenState.value = .loaded(name: "Andre Haas", email: "andre.haas@example.com", options: options)
  }

  func didSelectMenuItem(_ item: ProfileMenuItem) {
    if item.isDestructive {
      coordinator?.didRequestLogout()
    }
  }
}
