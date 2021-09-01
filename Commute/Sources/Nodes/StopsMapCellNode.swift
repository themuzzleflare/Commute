import UIKit
import AsyncDisplayKit
import Mapbox
import TfNSW

final class StopsMapCellNode: ASCellNode {
  var stopSequenceVC: StopSequenceVC

  private lazy var mapView: MGLMapView = {
    let mapView = MGLMapView(frame: .zero)
    mapView.styleURL = MGLStyle.commuteStyleURL
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.delegate = self
    return mapView
  }()

  private lazy var mapNode = ASDisplayNode { () -> MGLMapView in
    return self.mapView
  }

  init(_ viewController: StopSequenceVC, stops: [TripRequestResponseJourneyLegStop]) {
    self.stopSequenceVC = viewController
    super.init()

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polyine = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))

    mapView.frame = bounds
    mapView.addAnnotation(polyine)
    mapView.setCenter(stops.first!.location!.coordinate, zoomLevel: 13.0, animated: false)
    mapNode.style.minHeight = ASDimension(unit: .points, value: 300)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}

extension StopsMapCellNode: MGLMapViewDelegate {
  func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    stopSequenceVC.delegate = self
  }
}

extension StopsMapCellNode: StopSequenceDelegate {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop) {
    let camera = MGLMapCamera(lookingAtCenter: stop.location!.coordinate, altitude: mapView.camera.altitude, pitch: mapView.camera.pitch, heading: mapView.camera.heading)
    mapView.fly(to: camera)
  }
}
