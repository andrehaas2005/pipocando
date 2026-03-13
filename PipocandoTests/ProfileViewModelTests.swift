import XCTest
@testable import Pipocando

@MainActor
final class ProfileViewModelTests: XCTestCase {

  private final class ProfileRoutingSpy: ProfileRouting {
    var didRequestLogoutCallCount = 0

    func didRequestLogout() {
      didRequestLogoutCallCount += 1
    }
  }

  func testFetchDataEmitsLoadedState() {
    let sut = ProfileViewModel()
    sut.fetchData()

    guard let state = sut.screenState.value else {
      return XCTFail("Expected state")
    }

    switch state {
    case .loaded(let name, let email, let options):
      XCTAssertFalse(name.isEmpty)
      XCTAssertFalse(email.isEmpty)
      XCTAssertFalse(options.isEmpty)
    default:
      XCTFail("Expected loaded state")
    }
  }

  func testSelectingDestructiveItemRequestsLogoutRoute() {
    let routing = ProfileRoutingSpy()
    let sut = ProfileViewModel()
    sut.coordinator = routing

    let item = ProfileMenuItem(title: "Sair", icon: "arrow.right.square", isDestructive: true)
    sut.didSelectMenuItem(item)

    XCTAssertEqual(routing.didRequestLogoutCallCount, 1)
  }
}
