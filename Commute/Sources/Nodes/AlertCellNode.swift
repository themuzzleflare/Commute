import SwiftDate
import UIKit
import AsyncDisplayKit

final class AlertCellNode: ASCellNode {
  private let headerTextNode = ASTextNode()
  private let activePeriodTextNode = ASTextNode()

  init(alert: TransitRealtime_Alert) {
    super.init()

    let fromDate = Date(seconds: TimeInterval(alert.activePeriod[0].start))
    let toDate = Date(seconds: TimeInterval(alert.activePeriod[0].end))

    automaticallyManagesSubnodes = true

    accessoryType = .disclosureIndicator

    headerTextNode.attributedText = NSAttributedString(
      text: alert.headerText.translation.first?.text,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    activePeriodTextNode.attributedText = NSAttributedString(
      text: "\(fromDate.toString(.date(.medium))) to \(toDate.toString(.date(.medium)))",
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
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

    return ASInsetLayoutSpec(insets: .cellNode, child: hStack)
  }
}
