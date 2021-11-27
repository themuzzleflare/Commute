import UIKit
import AsyncDisplayKit
import BonMot

final class StationCellNode: ASCellNode {
  private let stationNameTextNode = ASTextNode()
  private let distanceTextNode = ASTextNode()
  
  private var station: StationViewModel

  init(station: StationViewModel) {
    self.station = station
    super.init()
    automaticallyManagesSubnodes = true
    stationNameTextNode.attributedText = station.name.styled(with: .commute)
    distanceTextNode.attributedText = station.distance.styled(with: .stationDistance)
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
  
  override func layout() {
    super.layout()
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let vStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: station.type == .byName ? [stationNameTextNode] : [
        stationNameTextNode,
        distanceTextNode
      ]
    )

    return ASInsetLayoutSpec(insets: .cellNode, child: vStack)
  }
}
