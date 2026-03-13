import UIKit

final class LoadingView: UIView {
  private let indicator = UIActivityIndicatorView(style: .large)

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Color.backgroundDark
    indicator.color = Color.primary
    indicator.startAnimating()
    addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
