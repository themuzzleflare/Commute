import UIKit
import AsyncDisplayKit

final class RightDetailCellNode: ASCellNode {
  let leftTextNode = ASTextNode()
  let rightTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    leftTextNode.attributedText = NSAttributedString(
      string: text,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .body),
        .foregroundColor: UIColor.label,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    rightTextNode.attributedText = NSAttributedString(
      string: detailText,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .body),
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: ModelFacade.pRightStyle
      ]
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

    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16), child: hStack)
  }
}
