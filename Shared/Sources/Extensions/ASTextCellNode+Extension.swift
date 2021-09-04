import Foundation
import UIKit
import AsyncDisplayKit

extension ASTextCellNode {
  convenience init(text: String?, font: UIFont? = nil, colour: UIColor? = nil, alignment: NSParagraphStyle? = nil, selectionStyle: UITableViewCell.SelectionStyle? = nil, accessoryType: UITableViewCell.AccessoryType? = nil) {
    self.init(
      attributes: [
        NSAttributedString.Key.font: font ?? .newFrankRegular(size: UIFont.labelFontSize),
        NSAttributedString.Key.foregroundColor: colour ?? .label,
        NSAttributedString.Key.paragraphStyle: alignment ?? .leftAligned
      ],
      insets: .cellNode
    )
    self.text = text
    self.selectionStyle = selectionStyle ?? .default
    self.accessoryType = accessoryType ?? .none
  }
}
