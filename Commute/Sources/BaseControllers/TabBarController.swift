import UIKit
import AsyncDisplayKit
import Rswift

final class TabBarController: ASTabBarController {
  private let tripsvc: UIViewController = {
    let vc = NavigationController(rootViewController: TripsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Trips",
      image: R.image.tram(),
      selectedImage: R.image.tramFill()
    )

    return vc
  }()

  private let stationsvc: UIViewController = {
    let vc = NavigationController(rootViewController: StationsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Stations",
      image: R.image.location(),
      selectedImage: R.image.locationFill()
    )

    return vc
  }()

  private let toolsvc: UIViewController = {
    let vc = NavigationController(rootViewController: ToolsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Tools",
      image: R.image.gearshape(),
      selectedImage: R.image.gearshapeFill()
    )

    return vc
  }()

  private let aboutvc: UIViewController = {
    let vc = NavigationController(rootViewController: AboutVC())

    vc.tabBarItem = UITabBarItem(
      title: "About",
      image: R.image.infoCircle(),
      selectedImage: R.image.infoCircleFill()
    )

    return vc
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  private func configure() {
    setViewControllers([tripsvc, stationsvc, toolsvc, aboutvc], animated: true)
  }
}
