import TfNSW
import UIKit
import AsyncDisplayKit

final class LegCellNode: ASCellNode {
  private let relativeTimeDisplayNode = ASDisplayNode()
  private let relativeTimeTextNode = ASTextNode()
  private let fromNameTextNode = ASTextNode()
  private let fromTimeTextNode = ASTextNode()
  private let durationTextNode = ASTextNode()
  private let toNameTextNode = ASTextNode()
  private let toTimeTextNode = ASTextNode()
  private let transportationNameTextNode = ASTextNode()

  init(legs: [TripRequestResponseJourneyLeg], index: Int) {
    super.init()

    let leg = legs[index]

    automaticallyManagesSubnodes = true

    relativeTimeDisplayNode.backgroundColor = leg.colour
    relativeTimeDisplayNode.style.preferredSize = CGSize(width: 80, height: 120)

    relativeTimeTextNode.attributedText = NSAttributedString(
      text: index == 0 ? leg.relativeDepartureTime : leg.relativeWaitTime(for: legs[index - 1]),
      font: .newFrankRegular(size: UIFont.systemFontSize),
      colour: .white,
      alignment: .centreAligned
    )

    fromNameTextNode.attributedText = NSAttributedString(
      text: leg.fromName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    fromTimeTextNode.attributedText = NSAttributedString(
      text: leg.fromTime,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    durationTextNode.attributedText = NSAttributedString(
      text: leg.durationText,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    toNameTextNode.attributedText = NSAttributedString(
      text: leg.toName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel,
      alignment: .rightAligned
    )

    toTimeTextNode.attributedText = NSAttributedString(
      text: leg.toTime,
      font: .newFrankBold(size: UIFont.labelFontSize),
      alignment: .rightAligned
    )

    transportationNameTextNode.attributedText = NSAttributedString(
      text: leg.isWheelchairAccessible ?? false ? "\(leg.transportationName ?? "") ♿️" : leg.transportationName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel,
      alignment: .rightAligned
    )
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let fromStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: [
        fromNameTextNode,
        fromTimeTextNode,
        durationTextNode
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
        toNameTextNode,
        toTimeTextNode,
        transportationNameTextNode
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

    let insetStack = ASInsetLayoutSpec(insets: .cellNode, child: hStack)

    insetStack.style.flexShrink = 1.0
    insetStack.style.flexGrow = 1.0

    let textCentreSpec = ASCenterLayoutSpec(
      centeringOptions: .XY,
      sizingOptions: .minimumXY,
      child: relativeTimeTextNode
    )

    let overlaySpec = ASOverlayLayoutSpec(child: relativeTimeDisplayNode, overlay: textCentreSpec)

    let finalStack = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .start,
      alignItems: .center,
      children: [
        overlaySpec,
        insetStack
      ]
    )

    return ASInsetLayoutSpec(insets: .zero, child: finalStack)
  }
}
