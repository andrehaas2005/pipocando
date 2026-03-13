import UIKit

enum Elevation {
  static let none: CGFloat = 0
  static let sm: CGFloat = 2
  static let md: CGFloat = 6
  static let lg: CGFloat = 12

  static func apply(level: CGFloat, to layer: CALayer) {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowRadius = level
    layer.shadowOffset = CGSize(width: 0, height: level / 2)
  }
}
