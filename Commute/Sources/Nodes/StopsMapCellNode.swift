import TfNSW
import UIKit
import AsyncDisplayKit
import MapboxMaps

final class StopsMapCellNode: ASCellNode {
  private var stopSequenceViewController: StopSequenceVC
  private var stops: [TripRequestResponseJourneyLegStop]

  private let mapNode = MapboxMapNode()

  init(_ viewController: StopSequenceVC, stops: [TripRequestResponseJourneyLegStop]) {
    self.stopSequenceViewController = viewController
    self.stops = stops
    super.init()

    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polylineManager = mapNode.rootView.annotations.makePolylineAnnotationManager()
    let annotation = PolylineAnnotation(lineCoordinates: coordinates)
    polylineManager.annotations = [annotation]
    
    if let location = stops.first?.location {
      let cameraOptions = CameraOptions(center: location.coordinate, zoom: 16.45)
      mapNode.rootView.mapboxMap.setCamera(to: cameraOptions)
    }

    automaticallyManagesSubnodes = true

    selectionStyle = .none

    mapNode.style.minHeight = ASDimension(unit: .points, value: 300)
    
    mapNode.rootView.mapboxMap.onNext(.mapLoaded) { (_) in
      self.stopSequenceViewController.delegate = self
    }
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}

extension StopsMapCellNode: StopSequenceDelegate {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop) {
    if let location = stop.location {
      let cameraOptions = CameraOptions(center: location.coordinate, zoom: 15)
      mapNode.rootView.camera.fly(to: cameraOptions, duration: 1)
    }
  }
}
