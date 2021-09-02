import Foundation
import UIKit

extension NSAttributedString {
  convenience init(string: String?, font: UIFont? = nil, colour: UIColor? = nil, alignment: NSParagraphStyle? = nil) {
    self.init(
      string: string ?? "",
      attributes: [
        .font: font ?? .newFrankRegular(size: UIFont.labelFontSize),
        .foregroundColor: colour ?? .label,
        .paragraphStyle: alignment ?? .leftAligned
      ]
    )
  }
}
