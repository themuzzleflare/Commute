import SwiftDate
import UIKit
import AsyncDisplayKit
import BonMot

final class AlertCellNode: ASCellNode {
  private let headerTextNode = ASTextNode()
  private let activePeriodTextNode = ASTextNode()
  
  private var alert: TransitRealtime_Alert
  private var fromDate: Date {
    return Date(seconds: TimeInterval(alert.activePeriod[0].start))
  }
  private var toDate: Date {
    return Date(seconds: TimeInterval(alert.activePeriod[0].end))
  }

  init(alert: TransitRealtime_Alert) {
    self.alert = alert
    super.init()
    automaticallyManagesSubnodes = true
    headerTextNode.attributedText = alert.headerText.translation.first?.text.styled(with: .commuteBold)
    activePeriodTextNode.attributedText = "\(fromDate.toString(.date(.medium))) to \(toDate.toString(.date(.medium)))".styled(with: .stationDistance)
  }
  
  deinit {
    print(#function)
  }
  
  override func layout() {
    super.layout()
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let vStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .center,
      alignItems: .start,
      children: [
        headerTextNode,
        activePeriodTextNode
      ]
    )
    return ASInsetLayoutSpec(insets: .cellNode, child: vStack)
  }
}
