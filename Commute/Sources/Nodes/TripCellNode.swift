import BonMot
import UIKit
import AsyncDisplayKit

final class TripCellNode: ASCellNode {
  private let tripNameTextNode = ASTextNode()
  private var trip: TripViewModel
  
  init(trip: TripViewModel) {
    self.trip = trip
    super.init()
    
    automaticallyManagesSubnodes = true
    
    let style = StringStyle(
      .alignment(.left),
      .font(.newFrankRegular(size: UIFont.labelFontSize)),
      .color(.label)
    )
    
    tripNameTextNode.attributedText = trip.name.styled(with: style)
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
    return ASInsetLayoutSpec(insets: .cellNode, child: tripNameTextNode)
  }
}
