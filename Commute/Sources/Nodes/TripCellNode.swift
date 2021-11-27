import UIKit
import AsyncDisplayKit
import BonMot

final class TripCellNode: ASCellNode {
  private let tripNameTextNode = ASTextNode()
  
  private var trip: TripViewModel
  
  init(trip: TripViewModel) {
    self.trip = trip
    super.init()
    automaticallyManagesSubnodes = true
    tripNameTextNode.attributedText = trip.name.styled(with: .commute)
  }
  
  override func layout() {
    super.layout()
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .cellNode, child: tripNameTextNode)
  }
}
