import UIKit
import AsyncDisplayKit
import CoreLocation

class ASViewController: ASDKViewController<ASDisplayNode> {
  let displayNode = ASDisplayNode()

  var locationManager: CLLocationManager?

  override init() {
    super.init(node: displayNode)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureLocationManager()
  }

  private func configureView() {
    view.backgroundColor = .systemBackground
  }

  private func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestWhenInUseAuthorization()
  }
}

extension ASViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse: manager.startUpdatingLocation()
    case .authorizedAlways: manager.startUpdatingLocation()
    default: break
    }
  }
}
