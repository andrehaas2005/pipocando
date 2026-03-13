import UIKit

final class TagView: UIView {
  private let label = UILabel()

  init(text: String) {
    super.init(frame: .zero)
    label.text = text
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    backgroundColor = Color.surface
    layer.cornerRadius = Radius.pill

    label.font = Typography.captionStrong
    label.textColor = .white

    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.xxs),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.xxs),
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.sm),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.sm)
    ])
  }
}
