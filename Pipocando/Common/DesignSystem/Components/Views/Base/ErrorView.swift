import UIKit

final class ErrorView: UIView {
  private let messageLabel = UILabel()
  private let retryButton = SecondaryButton()

  var onRetry: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear

    messageLabel.font = Typography.body
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center

    retryButton.setTitle("Tentar novamente", for: .normal)
    retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

    let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
    stack.axis = .vertical
    stack.spacing = Spacing.sm
    stack.alignment = .center

    addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Spacing.md),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Spacing.md)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(message: String) {
    messageLabel.text = message
  }

  @objc private func didTapRetry() {
    onRetry?()
  }
}
