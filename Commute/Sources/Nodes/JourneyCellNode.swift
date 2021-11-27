import TfNSW
import UIKit
import AsyncDisplayKit
import BonMot

final class JourneyCellNode: ASCellNode {
  private let relativeTimeDisplayNode = ASDisplayNode()
  private let relativeTimeTextNode = ASTextNode()
  private let fromNameTextNode = ASTextNode()
  private let fromTimeTextNode = ASTextNode()
  private let totalDurationTextNode = ASTextNode()
  private let toNameTextNode = ASTextNode()
  private let toTimeTextNode = ASTextNode()
  private let transportationNamesTextNode = ASTextNode()
  
  private var journey: TripRequestResponseJourney

  init(journey: TripRequestResponseJourney) {
    self.journey = journey
    super.init()
    automaticallyManagesSubnodes = true

    relativeTimeDisplayNode.backgroundColor = journey.colour
    relativeTimeDisplayNode.style.preferredSize = CGSize(width: 80, height: 120)

    relativeTimeTextNode.attributedText = NSAttributedString(
      text: journey.relativeDepartureTime,
      font: .newFrankRegular(size: UIFont.systemFontSize),
      colour: .white,
      alignment: .centreAligned
    )

    fromNameTextNode.attributedText = NSAttributedString(
      text: journey.fromName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    fromTimeTextNode.attributedText = NSAttributedString(
      text: journey.fromTime,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    totalDurationTextNode.attributedText = NSAttributedString(
      text: journey.totalDurationText,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )

    toNameTextNode.attributedText = NSAttributedString(
      text: journey.toName,
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel,
      alignment: .rightAligned
    )

    toTimeTextNode.attributedText = NSAttributedString(
      text: journey.toTime,
      font: .newFrankBold(size: UIFont.labelFontSize),
      alignment: .rightAligned
    )

    transportationNamesTextNode.attributedText = NSAttributedString(
      text: journey.transportationNames,
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
        totalDurationTextNode
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
        transportationNamesTextNode
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
