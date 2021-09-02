import UIKit
import AsyncDisplayKit
import TfNSW

final class LegCellNode: ASCellNode {
  private let relativeTimeDisplayNode = ASDisplayNode()
  private let relativeTimeTextNode = ASTextNode2()
  private let fromNameTextNode = ASTextNode2()
  private let fromTimeTextNode = ASTextNode2()
  private let durationTextNode = ASTextNode2()
  private let toNameTextNode = ASTextNode2()
  private let toTimeTextNode = ASTextNode2()
  private let transportationNameTextNode = ASTextNode2()

  init(legs: [TripRequestResponseJourneyLeg], index: Int) {
    super.init()

    let leg = legs[index]

    automaticallyManagesSubnodes = true

    relativeTimeDisplayNode.backgroundColor = leg.colour
    relativeTimeDisplayNode.style.preferredSize = CGSize(width: 80, height: 120)

    relativeTimeTextNode.attributedText = NSAttributedString(
      string: index == 0 ? leg.relativeDepartureTime : leg.relativeWaitTime(for: legs[index - 1]),
      font: .newFrankRegular(size: UIFont.systemFontSize),
      colour: .white,
      alignment: .centreAligned
    )

    fromNameTextNode.attributedText = NSAttributedString(
      string: leg.fromName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    fromTimeTextNode.attributedText = NSAttributedString(
      string: leg.fromTime,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    durationTextNode.attributedText = NSAttributedString(
      string: leg.durationText,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    toNameTextNode.attributedText = NSAttributedString(
      string: leg.toName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel,
      alignment: .rightAligned
    )

    toTimeTextNode.attributedText = NSAttributedString(
      string: leg.toTime,
      font: .newFrankBold(size: UIFont.labelFontSize),
      alignment: .rightAligned
    )

    transportationNameTextNode.attributedText = NSAttributedString(
      string: leg.isWheelchairAccessible ?? false ? "\(leg.transportationName ?? "") ♿️" : leg.transportationName,
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

    finalStack.style.minHeight = ASDimension(unit: .points, value: 120)
    finalStack.style.maxHeight = ASDimension(unit: .points, value: 120)

    return ASInsetLayoutSpec(insets: .zero, child: finalStack)
  }
}
