import UIKit

final class PrimaryButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupStyle() {
    backgroundColor = Color.primary
    setTitleColor(.white, for: .normal)
    titleLabel?.font = Typography.bodyMedium
    layer.cornerRadius = Radius.md
    Elevation.apply(level: Elevation.sm, to: layer)
    contentEdgeInsets = UIEdgeInsets(top: Spacing.sm, left: Spacing.md, bottom: Spacing.sm, right: Spacing.md)
  }
}
