import UIKit
import AsyncDisplayKit
import Rswift
import TfNSW

final class JourneyCellNode: ASCellNode {
  private let relativeTimeDisplayNode = ASDisplayNode()
  private let relativeTimeTextNode = ASTextNode()
  private let fromNameTextNode = ASTextNode()
  private let fromTimeTextNode = ASTextNode()
  private let totalDurationTextNode = ASTextNode()
  private let toNameTextNode = ASTextNode()
  private let toTimeTextNode = ASTextNode()
  private let transportationNamesTextNode = ASTextNode()

  init(journey: TripRequestResponseJourney) {
    super.init()

    automaticallyManagesSubnodes = true

    relativeTimeDisplayNode.backgroundColor = journey.colour
    relativeTimeDisplayNode.style.preferredSize = CGSize(width: 80, height: 120)

    relativeTimeTextNode.attributedText = NSAttributedString(
      string: journey.relativeDepartureTime ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.systemFontSize)!,
        .foregroundColor: UIColor.white,
        .paragraphStyle: NSParagraphStyle.centreAligned
      ]
    )

    fromNameTextNode.attributedText = NSAttributedString(
      string: journey.fromName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    fromTimeTextNode.attributedText = NSAttributedString(
      string: journey.fromTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    totalDurationTextNode.attributedText = NSAttributedString(
      string: journey.totalDurationText,
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    toNameTextNode.attributedText = NSAttributedString(
      string: journey.toName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.rightAligned
      ]
    )

    toTimeTextNode.attributedText = NSAttributedString(
      string: journey.toTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.rightAligned
      ]
    )

    transportationNamesTextNode.attributedText = NSAttributedString(
      string: journey.transportationNames ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.rightAligned
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

    let insetStack = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16), child: hStack)

    insetStack.style.flexShrink = 1.0
    insetStack.style.flexGrow = 1.0

    let textCentreSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: relativeTimeTextNode)
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
