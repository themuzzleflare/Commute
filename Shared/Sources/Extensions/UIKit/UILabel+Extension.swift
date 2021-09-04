import Foundation
import UIKit

extension UILabel {
  convenience init(text: String?, font: UIFont? = nil, textColour: UIColor? = nil, textAlignment: NSTextAlignment? = nil, numberOfLines: Int? = nil) {
    self.init()
    self.font = font ?? .newFrankRegular(size: UIFont.labelFontSize)
    self.textColor = textColour ?? .label
    self.textAlignment = textAlignment ?? .left
    self.numberOfLines = numberOfLines ?? 1
    self.text = text
  }

  static func backgroundLabelTitle(text: String) -> UILabel {
    return UILabel(
      text: text,
      font: .newFrankMedium(size: 32),
      textColour: .placeholderText,
      textAlignment: .center
    )
  }

  static func backgroundLabelDescription(text: String) -> UILabel {
    return UILabel(
      text: text,
      textColour: .placeholderText,
      textAlignment: .center,
      numberOfLines: 0
    )
  }
}
