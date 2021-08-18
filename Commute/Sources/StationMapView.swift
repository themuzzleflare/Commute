import UIKit
import Mapbox

final class StationMapView: UIViewController {
  private var station: Station

  private let mapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/themuzzleflare/cksfqc1moanss17qt9mp2bpx1"))

  init(station: Station) {
    self.station = station
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    configureMapView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    mapView.frame = view.bounds
  }

  private func configureMapView() {
    mapView.setCenter(station.location.coordinate, zoomLevel: 16.45, animated: false)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}
