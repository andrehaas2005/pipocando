import UIKit

final class SecondaryButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupStyle() {
    backgroundColor = .clear
    setTitleColor(Color.primary, for: .normal)
    titleLabel?.font = Typography.bodyMedium
    layer.cornerRadius = Radius.md
    layer.borderColor = Color.primary.cgColor
    layer.borderWidth = 1
    contentEdgeInsets = UIEdgeInsets(top: Spacing.sm, left: Spacing.md, bottom: Spacing.sm, right: Spacing.md)
  }
}
