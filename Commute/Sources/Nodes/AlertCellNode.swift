import UIKit
import AsyncDisplayKit
import SwiftDate
import Rswift

final class AlertCellNode: ASCellNode {
  private let headerTextNode = ASTextNode()
  private let activePeriodTextNode = ASTextNode()

  init(alert: TransitRealtime_Alert) {
    super.init()

    automaticallyManagesSubnodes = true

    accessoryType = .disclosureIndicator

    headerTextNode.attributedText = NSAttributedString(
      string: alert.headerText.translation[0].text,
      attributes: [
        .font: R.font.newFrankBold(size: UIFont.labelFontSize)!,
        .foregroundColor: UIColor.label,
        .paragraphStyle: NSParagraphStyle.leftAligned
      ]
    )

    let fromDate = Date(seconds: TimeInterval(alert.activePeriod[0].start))
    let toDate = Date(seconds: TimeInterval(alert.activePeriod[0].end))

    activePeriodTextNode.attributedText = NSAttributedString(
      string: "\(fromDate.toString(.date(.medium))) to \(toDate.toString(.date(.medium)))",
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
      justifyContent: .center,
      alignItems: .start,
      children: [
        headerTextNode,
        activePeriodTextNode
      ]
    )

    hStack.style.minHeight = ASDimension(unit: .points, value: 80)

    return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16), child: hStack)
  }
}
