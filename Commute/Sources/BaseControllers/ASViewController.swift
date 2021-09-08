import CoreLocation
import UIKit
import AsyncDisplayKit

class ASViewController: ASDKViewController<ASDisplayNode> {
  var locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNode()
    configureLocationManager()
  }

  private func configureNode() {
    node.backgroundColor = .systemBackground
  }

  private func configureLocationManager() {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
}

extension ASViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse:
      manager.startUpdatingLocation()
    case .authorizedAlways:
      manager.startUpdatingLocation()
    default:
      break
    }
  }
}
