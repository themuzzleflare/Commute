import UIKit
import AsyncDisplayKit
import SwiftDate
import Rswift

final class JourneyCellNode: ASCellNode {
  private let fromNameNode = ASTextNode()
  private let relativeTimeNode = ASTextNode()
  private let fromTimeNode = ASTextNode()
  private let toNameNode = ASTextNode()
  private let toTimeNode = ASTextNode()

  init(journey: Journey) {
    super.init()

    automaticallyManagesSubnodes = true

    fromNameNode.attributedText = NSAttributedString(
      string: journey.fromName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    relativeTimeNode.attributedText = NSAttributedString(
      string: journey.relativeTime ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: journey.relativeTimeInPast ?? false ? UIColor.systemRed : UIColor.systemGreen,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    fromTimeNode.attributedText = NSAttributedString(
      string: journey.fromTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: ModelFacade.pLeftStyle
      ]
    )

    toNameNode.attributedText = NSAttributedString(
      string: journey.toName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: ModelFacade.pRightStyle
      ]
    )

    toTimeNode.attributedText = NSAttributedString(
      string: journey.toTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
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
