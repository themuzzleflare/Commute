import UIKit
import AsyncDisplayKit

final class StationByNameCellNode: ASCellNode {
  private let stationNameTextNode = ASTextNode()

  init(station: Station) {
    super.init()

    automaticallyManagesSubnodes = true

    stationNameTextNode.attributedText = NSAttributedString(text: station.shortName)
  }
  
  override var isSelected: Bool {
    didSet {
      backgroundColor = isSelected ? .gray.withAlphaComponent(0.3) : .clear
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      backgroundColor = isHighlighted ? .gray.withAlphaComponent(0.3) : .clear
    }
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .cellNode, child: stationNameTextNode)
  }
}
