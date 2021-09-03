import TfNSW
import UIKit
import AsyncDisplayKit
import Mapbox

final class StopsMapCellNode: ASCellNode {
  private var stopSequenceViewController: StopSequenceVC

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
    self.stopSequenceViewController = viewController
    super.init()

    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polyine = MGLPolyline(coordinates: coordinates, count: coordinates.count.uInt)

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapView.frame = bounds
    mapView.addAnnotation(polyine)

    if let location = stops.first?.location {
      mapView.setCenter(location.coordinate, zoomLevel: 16.45, animated: false)
    }

    mapNode.style.minHeight = ASDimension(unit: .points, value: 300)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}

extension StopsMapCellNode: MGLMapViewDelegate {
  func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
    stopSequenceViewController.delegate = self
  }
}

extension StopsMapCellNode: StopSequenceDelegate {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop) {
    if let location = stop.location {
      let camera = MGLMapCamera(
        lookingAtCenter: location.coordinate,
        altitude: mapView.camera.altitude,
        pitch: mapView.camera.pitch,
        heading: mapView.camera.heading
      )

      mapView.fly(to: camera)
    }
  }
}
