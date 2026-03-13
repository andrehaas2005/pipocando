import XCTest
@testable import Pipocando

@MainActor
final class DesignSystemSnapshotTests: XCTestCase {

  func testPrimaryButtonRenders() {
    let button = PrimaryButton(frame: CGRect(x: 0, y: 0, width: 180, height: 48))
    button.setTitle("Assistir", for: .normal)

    let image = renderImage(from: button)
    XCTAssertNotNil(image)
  }

  func testErrorViewRenders() {
    let view = ErrorView(frame: CGRect(x: 0, y: 0, width: 320, height: 240))
    view.configure(message: "Falha ao carregar")

    let image = renderImage(from: view)
    XCTAssertNotNil(image)
  }

  private func renderImage(from view: UIView) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { _ in
      view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
  }
}
