import UIKit
import CoreLocation
import AsyncDisplayKit

final class StationByDistanceCellNode: ASCellNode {
  private let stationNameTextNode = ASTextNode()
  private let distanceTextNode = ASTextNode()

  init(station: Station, relativeLocation: CLLocation?) {
    super.init()

    automaticallyManagesSubnodes = true

    stationNameTextNode.attributedText = NSAttributedString(text: station.shortName)

    distanceTextNode.attributedText = NSAttributedString(
      text: "\(NumberFormatter.twoDecimalPlaces.string(from: station.location.distance(from: relativeLocation ?? CLLocation()).kilometres.nsNumber) ?? "") km",
      font: .newFrankRegular(size: UIFont.smallSystemFontSize),
      colour: .secondaryLabel
    )
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
    let hStack = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      children: [
        stationNameTextNode,
        distanceTextNode
      ]
    )

    return ASInsetLayoutSpec(insets: .cellNode, child: hStack)
  }
}
