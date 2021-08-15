import UIKit
import AsyncDisplayKit

final class StationMapCellNode: ASCellNode {
  let mapNode = ASMapNode()

  init(station: Station) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapNode.style.preferredSize = CGSize(width: 300, height: 300)
    mapNode.region = MKCoordinateRegion(center: station.location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    mapNode.isLiveMap = true
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}
