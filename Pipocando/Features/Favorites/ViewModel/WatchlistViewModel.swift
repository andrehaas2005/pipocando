import Foundation

protocol WatchlistRouting: AnyObject {
  func showWatchedHistory()
}

struct WatchlistItem {
  let title: String
  let rating: String
  let image: String?
}

enum WatchlistState {
  case idle
  case loading
  case loaded([WatchlistItem])
  case error(AppError)
}

@MainActor
final class WatchlistViewModel {
  weak var coordinator: (any WatchlistRouting)?
  let screenState = Observable<WatchlistState>(.idle)

  init(coordinator: any WatchlistRouting) {
    self.coordinator = coordinator
  }

  func fetchData() {
    screenState.value = .loading

    let items = [
      WatchlistItem(title: "Interestelar", rating: "9.5", image: nil),
      WatchlistItem(title: "O Poderoso Chefão", rating: "8.8", image: nil),
      WatchlistItem(title: "Spider-Man", rating: "9.2", image: nil),
      WatchlistItem(title: "Pulp Fiction", rating: "8.0", image: nil),
      WatchlistItem(title: "Blade Runner 2049", rating: "9.0", image: nil),
      WatchlistItem(title: "Breaking Bad", rating: "9.8", image: nil)
    ]

    screenState.value = .loaded(items)
  }

  func didSelectMovie(at index: Int) {
    guard case .loaded(let items) = screenState.value,
          items.indices.contains(index) else { return }
    coordinator?.showWatchedHistory()
  }
}
