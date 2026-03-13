import XCTest
@testable import Pipocando

@MainActor
final class WatchlistViewModelTests: XCTestCase {

  private final class WatchlistRoutingSpy: WatchlistRouting {
    var showHistoryCallCount = 0

    func showWatchedHistory() {
      showHistoryCallCount += 1
    }
  }

  func testFetchDataEmitsLoadedState() {
    let routing = WatchlistRoutingSpy()
    let sut = WatchlistViewModel(coordinator: routing)

    sut.fetchData()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected state")
    }

    switch state {
    case .loaded(let items):
      XCTAssertFalse(items.isEmpty)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testDidSelectMovieRoutesToHistory() {
    let routing = WatchlistRoutingSpy()
    let sut = WatchlistViewModel(coordinator: routing)
    sut.fetchData()

    sut.didSelectMovie(at: 0)

    XCTAssertEqual(routing.showHistoryCallCount, 1)
  }
}
