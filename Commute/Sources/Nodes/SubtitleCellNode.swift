import UIKit
import AsyncDisplayKit

final class SubtitleCellNode: ASCellNode {
  let topTextNode = ASTextNode()
  let bottomTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    topTextNode.attributedText = NSAttributedString(
      string: text,
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize),
        .foregroundColor: UIColor.label,
        .paragraphStyle: pLeftStyle
      ]
    )

    bottomTextNode.attributedText = NSAttributedString(
      string: detailText,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: pLeftStyle
      ]
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let hStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: (bottomTextNode.attributedText?.string.isEmpty)! ? [topTextNode] : [topTextNode, bottomTextNode]
    )

    return ASInsetLayoutSpec(
      insets: UIEdgeInsets(
        top: 13,
        left: 16,
        bottom: 13,
        right: 16
      ),
      child: hStack
    )
  }
}
