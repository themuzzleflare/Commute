import UIKit
import AsyncDisplayKit
import Rswift

final class RightDetailCellNode: ASCellNode {
  private let leftTextNode = ASTextNode()
  private let rightTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    leftTextNode.attributedText = NSAttributedString(
      string: text,
      attributes: [
        .font: R.font.newFrankMedium(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    rightTextNode.attributedText = NSAttributedString(
      string: detailText,
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.labelFontSize)!,
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
