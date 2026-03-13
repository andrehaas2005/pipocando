import UIKit

final class RatingBadge: UIView {
  private let icon = UIImageView(image: UIImage(systemName: "star.fill"))
  private let label = UILabel()

  init(rating: String) {
    super.init(frame: .zero)
    label.text = rating
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = Color.surface
    layer.cornerRadius = Radius.sm

    icon.tintColor = Color.accentYellow
    label.font = Typography.captionStrong
    label.textColor = .white

    let stack = UIStackView(arrangedSubviews: [icon, label])
    stack.axis = .horizontal
    stack.spacing = Spacing.xxs
    stack.alignment = .center

    addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.xxs),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.xxs),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.xs),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.xs)
    ])
  }
}
