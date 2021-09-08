import UIKit
import AsyncDisplayKit

final class StationByNameCellNode: ASCellNode {
  private let stationNameTextNode = ASTextNode()

  init(station: Station) {
    super.init()

    automaticallyManagesSubnodes = true

    stationNameTextNode.attributedText = NSAttributedString(text: station.shortName)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .cellNode, child: stationNameTextNode)
  }
}
