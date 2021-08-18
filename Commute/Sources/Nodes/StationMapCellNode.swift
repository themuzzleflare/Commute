import UIKit
import AsyncDisplayKit
import Mapbox

final class StationMapCellNode: ASCellNode {
  private lazy var mapView: MGLMapView = {
    let mapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/themuzzleflare/cksfqc1moanss17qt9mp2bpx1"))
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return mapView
  }()

  private lazy var mapNode = ASDisplayNode { () -> MGLMapView in
    return self.mapView
  }

  init(station: Station) {
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapView.frame = bounds
    mapView.setCenter(station.location.coordinate, zoomLevel: 16.45, animated: false)
    mapNode.style.preferredSize = CGSize(width: 300, height: 300)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}
