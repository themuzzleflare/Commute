import TfNSW
import UIKit
import AsyncDisplayKit
import MapboxMaps

final class StopsMapCellNode: ASCellNode {
  private let mapNode = MapboxMapNode()
  
  private weak var stopSequenceViewController: StopSequenceVC?
  private var stops: [TripRequestResponseJourneyLegStop]

  init(_ viewController: StopSequenceVC, stops: [TripRequestResponseJourneyLegStop]) {
    self.stopSequenceViewController = viewController
    self.stops = stops
    super.init()
    
    automaticallyManagesSubnodes = true
    selectionStyle = .none
    mapNode.style.minHeight = ASDimension(unit: .points, value: 400)

    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polylineManager = mapNode.rootView.annotations.makePolylineAnnotationManager()
    let annotation = PolylineAnnotation(lineCoordinates: coordinates)
    polylineManager.annotations = [annotation]
    
    if let location = stops.first?.location {
      let cameraOptions = CameraOptions(center: location.coordinate, zoom: 16.45)
      mapNode.rootView.mapboxMap.setCamera(to: cameraOptions)
    }
    
    mapNode.rootView.mapboxMap.onNext(.mapLoaded) { (_) in
      self.stopSequenceViewController?.delegate = self
    }
  }
  
  deinit {
    print(#function)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}

// MARK: - StopSequenceDelegate

extension StopsMapCellNode: StopSequenceDelegate {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop) {
    if let location = stop.location {
      let cameraOptions = CameraOptions(center: location.coordinate, zoom: 15)
      mapNode.rootView.camera.fly(to: cameraOptions, duration: 1)
    }
  }
}
