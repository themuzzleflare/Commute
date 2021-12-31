import TfNSW
import UIKit
import AsyncDisplayKit
import MapKit

final class StopsMapCellNode: ASCellNode {
  private let mapNode = ASMapNode()
  
  private weak var stopSequenceViewController: StopSequenceVC?
  
  private var stops: [TripRequestResponseJourneyLegStop]
  private var colour: UIColor

  init(_ viewController: StopSequenceVC, stops: [TripRequestResponseJourneyLegStop], colour: UIColor) {
    self.stopSequenceViewController = viewController
    self.stops = stops
    self.colour = colour
    super.init()
    
    automaticallyManagesSubnodes = true
    selectionStyle = .none
    mapNode.style.height = ASDimension(unit: .points, value: 400.0)

    if let location = stops.first?.location {
      let options = MKMapSnapshotter.Options()
      options.pointOfInterestFilter = MKPointOfInterestFilter(including: [.publicTransport])
      options.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
      mapNode.options = options
    }
    
    mapNode.mapDelegate = self
    mapNode.isLiveMap = true
  }
  
  deinit {
    print("\(#function) \(String(describing: type(of: self)))")
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: .zero, child: mapNode)
  }
}

// MARK: - MKMapViewDelegate

extension StopsMapCellNode: MKMapViewDelegate {
  func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    let coordinates = stops.compactMap { $0.location?.coordinate }
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    mapView.addOverlay(polyline)
    
    self.stopSequenceViewController?.delegate = self
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let overlay = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: overlay)
      renderer.strokeColor = colour
      renderer.lineWidth = 2.0
      return renderer
    }
    
    return MKOverlayRenderer()
  }
}

// MARK: - StopSequenceDelegate

extension StopsMapCellNode: StopSequenceDelegate {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop) {
    if let location = stop.location {
      mapNode.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
    }
  }
}
