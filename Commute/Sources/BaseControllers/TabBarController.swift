import UIKit
import AsyncDisplayKit

final class TabBarController: ASTabBarController {
  private let tripsvc: UIViewController = {
    let vc = NavigationController(rootViewController: TripsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Trips",
      image: UIImage(systemName: "tram"),
      selectedImage: UIImage(systemName: "tram.fill")
    )

    return vc
  }()

  private let stationsvc: UIViewController = {
    let vc = NavigationController(rootViewController: StationsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Stations",
      image: UIImage(systemName: "location"),
      selectedImage: UIImage(systemName: "location.fill")
    )

    return vc
  }()

  private let toolsvc: UIViewController = {
    let vc = NavigationController(rootViewController: ToolsVC())

    vc.tabBarItem = UITabBarItem(
      title: "Tools",
      image: UIImage(systemName: "gearshape"),
      selectedImage: UIImage(systemName: "gearshape.fill")
    )

    return vc
  }()

  private let aboutvc: UIViewController = {
    let vc = NavigationController(rootViewController: AboutVC())

    vc.tabBarItem = UITabBarItem(
      title: "About",
      image: UIImage(systemName: "info.circle"),
      selectedImage: UIImage(systemName: "info.circle.fill")
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
