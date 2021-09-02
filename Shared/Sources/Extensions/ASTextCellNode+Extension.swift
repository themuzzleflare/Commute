import Foundation
import UIKit
import AsyncDisplayKit

extension ASTextCellNode {
  convenience init(font: UIFont? = nil, colour: UIColor? = nil, alignment: NSParagraphStyle? = nil) {
    self.init(
      attributes: [
        NSAttributedString.Key.font: font ?? .newFrankRegular(size: UIFont.labelFontSize),
        NSAttributedString.Key.foregroundColor: colour ?? .label,
        NSAttributedString.Key.paragraphStyle: alignment ?? .leftAligned
      ],
      insets: .cellNode
    )
  }

  static func cellNode(string: String?, font: UIFont? = nil, colour: UIColor? = nil, alignment: NSParagraphStyle? = nil, selectionStyle: UITableViewCell.SelectionStyle? = nil, accessoryType: UITableViewCell.AccessoryType? = nil) -> ASTextCellNode {
    let node = ASTextCellNode(font: font, colour: colour, alignment: alignment)
    node.text = string
    node.selectionStyle = selectionStyle ?? .default
    node.accessoryType = accessoryType ?? .none
    return node
  }
}
