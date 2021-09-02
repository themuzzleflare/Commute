import UIKit
import AsyncDisplayKit

final class SubtitleCellNode: ASCellNode {
  private let topTextNode = ASTextNode()
  private let bottomTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    topTextNode.attributedText = NSAttributedString(
      string: text,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    bottomTextNode.attributedText = NSAttributedString(
      string: detailText,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let hStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: bottomTextNode.attributedText!.string.isEmpty ? [topTextNode] : [topTextNode, bottomTextNode]
    )

    return ASInsetLayoutSpec(insets: .cellNode, child: hStack)
  }
}
