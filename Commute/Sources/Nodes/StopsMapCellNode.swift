import TfNSW
import UIKit
import AsyncDisplayKit
import Mapbox

final class StopsMapCellNode: ASCellNode {
  private var stopSequenceViewController: StopSequenceVC
  private var stops: [TripRequestResponseJourneyLegStop]

  private let mapNode = MGLMapNode()

  init(_ viewController: StopSequenceVC, stops: [TripRequestResponseJourneyLegStop]) {
    self.stopSequenceViewController = viewController
    self.stops = stops
    super.init()

    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polyine = MGLPolyline(coordinates: coordinates, count: coordinates.count.uInt)

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapNode.styleURL = MGLStyle.commuteStyleURL
    mapNode.delegate = self
    mapNode.addAnnotation(polyine)

    if let location = stops.first?.location {
      mapNode.setCenter(location.coordinate, zoomLevel: 16.45, animated: false)
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
        altitude: mapNode.camera.altitude,
        pitch: mapNode.camera.pitch,
        heading: mapNode.camera.heading
      )

      mapNode.fly(to: camera)
    }
  }
}
