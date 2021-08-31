import UIKit
import AsyncDisplayKit
import Rswift
import TfNSW

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

    let relativeTimeText: String

    if index == 0 {
      relativeTimeText = leg.relativeDepartureTime ?? ""
    } else {
      relativeTimeText = leg.relativeWaitTime(for: legs[index - 1]) ?? ""
    }

    relativeTimeTextNode.attributedText = NSAttributedString(
      string: relativeTimeText,
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.systemFontSize)!,
        .foregroundColor: UIColor.white,
        .paragraphStyle: NSParagraphStyle.centreAligned
      ]
    )

    fromNameTextNode.attributedText = NSAttributedString(
      string: leg.fromName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    fromTimeTextNode.attributedText = NSAttributedString(
      string: leg.fromTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    durationTextNode.attributedText = NSAttributedString(
      string: leg.durationText,
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    toNameTextNode.attributedText = NSAttributedString(
      string: leg.toName ?? "",
      attributes: [
        .font: R.font.newFrankRegular(size: UIFont.smallSystemFontSize)!,
        .foregroundColor: UIColor.secondaryLabel,
        .paragraphStyle: NSParagraphStyle.rightAligned
      ]
    )

    toTimeTextNode.attributedText = NSAttributedString(
      string: leg.toTime ?? "",
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.rightAligned
      ]
    )

    transportationNameTextNode.attributedText = NSAttributedString(
      string: leg.isWheelchairAccessible ?? false ? "\(leg.transportationName ?? "") ♿️" : leg.transportationName ?? "",
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
