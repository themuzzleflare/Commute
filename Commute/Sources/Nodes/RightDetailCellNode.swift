import UIKit
import AsyncDisplayKit

final class RightDetailCellNode: ASCellNode {
  private let leftTextNode = ASTextNode()
  private let rightTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    leftTextNode.attributedText = NSAttributedString(
      string: text,
      font: .newFrankMedium(size: UIFont.labelFontSize)
    )

    rightTextNode.attributedText = NSAttributedString(
      string: detailText,
      colour: .secondaryLabel,
      alignment: .rightAligned
    )

    rightTextNode.style.flexShrink = 1.0
    rightTextNode.style.flexGrow = 1.0
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let hStack = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 5,
      justifyContent: .spaceBetween,
      alignItems: .center,
      children: [
        leftTextNode,
        rightTextNode
      ]
    )

    return ASInsetLayoutSpec(insets: .cellNode, child: hStack)
  }
}
