import Foundation
import UIKit

extension UILabel {
  static func backgroundLabelTitle(with string: String) -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .placeholderText
    label.font = .newFrankMedium(size: 32)
    label.text = string
    return label
  }

  static func backgroundLabelDescription(with string: String) -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .placeholderText
    label.font = .newFrankRegular(size: UIFont.labelFontSize)
    label.numberOfLines = 0
    label.text = string
    return label
  }
}
