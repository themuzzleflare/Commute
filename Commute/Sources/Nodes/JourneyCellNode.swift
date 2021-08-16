import UIKit
import AsyncDisplayKit
import SwiftDate

final class JourneyCellNode: ASCellNode {
  let fromNameNode = ASTextNode()
  let relativeTimeNode = ASTextNode()
  let fromTimeNode = ASTextNode()
  let toNameNode = ASTextNode()
  let toTimeNode = ASTextNode()

  init(journey: Journey) {
    super.init()

    automaticallyManagesSubnodes = true

    fromNameNode.attributedText = NSAttributedString(
      string: journey.fromName ?? "",
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    relativeTimeNode.attributedText = NSAttributedString(
      string: journey.relativeTime ?? "",
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: journey.relativeTimeInPast ?? false ? UIColor.systemRed : UIColor.systemGreen,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    fromTimeNode.attributedText = NSAttributedString(
      string: journey.fromTime ?? "",
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize),
        .foregroundColor: UIColor.label,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    toNameNode.attributedText = NSAttributedString(
      string: journey.toName ?? "",
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: ModelFacade.pRightStyle
      ]
    )

    toTimeNode.attributedText = NSAttributedString(
      string: journey.toTime ?? "",
      attributes: [
        .font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize),
        .foregroundColor: UIColor.label,
        .paragraphStyle: ModelFacade.pRightStyle
      ]
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let fromStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: [
        fromNameNode,
        relativeTimeNode,
        fromTimeNode
      ]
    )

    fromStack.style.flexShrink = 1.0
    fromStack.style.flexGrow = 1.0

    let toStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .end,
      children: [
        toNameNode,
        toTimeNode
      ]
    )

    toStack.style.flexShrink = 1.0
    toStack.style.flexGrow = 1.0

    let hStack = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .spaceBetween,
      alignItems: .center,
      children: [
        fromStack,
        toStack
      ]
    )

    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16), child: hStack)
  }
}
