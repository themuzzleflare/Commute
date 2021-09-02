import UIKit
import AsyncDisplayKit
import SwiftDate

final class AlertCellNode: ASCellNode {
  private let headerTextNode = ASTextNode2()
  private let activePeriodTextNode = ASTextNode2()

  init(alert: TransitRealtime_Alert) {
    super.init()

    let fromDate = Date(seconds: TimeInterval(alert.activePeriod[0].start))
    let toDate = Date(seconds: TimeInterval(alert.activePeriod[0].end))

    automaticallyManagesSubnodes = true

    accessoryType = .disclosureIndicator

    headerTextNode.attributedText = NSAttributedString(
      string: alert.headerText.translation.first?.text,
      font: .newFrankBold(size: UIFont.labelFontSize)
    )

    activePeriodTextNode.attributedText = NSAttributedString(
      string: "\(fromDate.toString(.date(.medium))) to \(toDate.toString(.date(.medium)))",
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
