import UIKit
import AsyncDisplayKit
import Mapbox

final class StationMapCellNode: ASCellNode {
  private let mapNode = MGLMapNode()

  init(station: Station) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapNode.styleURL = MGLStyle.commuteStyleURL
    mapNode.setCenter(station.location.coordinate, zoomLevel: 16.45, animated: false)
    mapNode.style.minHeight = ASDimension(unit: .points, value: 300)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}
