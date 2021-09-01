import UIKit
import AsyncDisplayKit
import Rswift

final class SubtitleCellNode: ASCellNode {
  private let topTextNode = ASTextNode()
  private let bottomTextNode = ASTextNode()

  init(text: String, detailText: String) {
    super.init()

    automaticallyManagesSubnodes = true

    topTextNode.attributedText = NSAttributedString(
      string: text,
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    bottomTextNode.attributedText = NSAttributedString(
      string: detailText,
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.leftAligned
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

    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16), child: hStack)
  }
}
