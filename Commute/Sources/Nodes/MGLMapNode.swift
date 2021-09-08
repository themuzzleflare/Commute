import UIKit
import AsyncDisplayKit
import Mapbox

final class MGLMapNode: ASDisplayNode {
  private let mapboxViewBlock: ASDisplayNodeViewBlock = {
    return MGLMapView()
  }

  private var mapView: MGLMapView {
    return view as! MGLMapView
  }

  override init() {
    super.init()
    setViewBlock(mapboxViewBlock)
  }
}

extension MGLMapNode {
  /// Subscribes an `MGLObserver` to a provided set of event types.
  func subscribe(for observer: MGLObserver, events: Set<MGLEventType>) {
    mapView.subscribe(for: observer, events: events)
  }

  /// Unsubscribes an `MGLObserver` from a provided set of event types.
  func unsubscribe(for observer: MGLObserver, events: Set<MGLEventType>) {
    mapView.unsubscribe(for: observer, events: events)
  }

  /// Unsubscribes an `MGLObserver` from all events (and release the strong reference).
  func unsubscribe(for observer: MGLObserver) {
    mapView.unsubscribe(for: observer)
  }

  /// Changes the center coordinate and zoom level of the map and optionally animates the change. For animated changes, wait until the map view has finished loading before calling this method.
  func setCenter(_ coordinate: CLLocationCoordinate2D, zoomLevel: Double, animated: Bool) {
    mapView.setCenter(coordinate, zoomLevel: zoomLevel, animated: animated)
  }

  /// Adds an annotation to the map view.
  func addAnnotation(_ annotation: MGLAnnotation) {
    mapView.addAnnotation(annotation)
  }

  /// Moves the viewpoint to a different location using a transition animation that evokes powered flight and a default duration based on the length of the flight path.
  func fly(to: MGLMapCamera) {
    mapView.fly(to: to)
  }

  /// URL of the style currently displayed in the receiver.
  var styleURL: URL? {
    get {
      return mapView.styleURL
    }
    set {
      mapView.styleURL = newValue
    }
  }

  /// The receiver's delegate.
  var delegate: MGLMapViewDelegate? {
    get {
      return mapView.delegate
    }
    set {
      mapView.delegate = newValue
    }
  }

  /// A camera representing the current viewpoint of the map.
  var camera: MGLMapCamera {
    return mapView.camera
  }
}
