import Foundation
import UIKit

extension UIViewController {
  static var trips: UIViewController {
    let viewController = NavigationController(rootViewController: TripsVC())
    viewController.tabBarItem = UITabBarItem(
      title: "Trips",
      image: .tram,
      selectedImage: .tramFill
    )
    return viewController
  }

  static var stations: UIViewController {
    let viewController = NavigationController(rootViewController: StationsVC())
    viewController.tabBarItem = UITabBarItem(
      title: "Stations",
      image: .location,
      selectedImage: .locationFill
    )
    return viewController
  }

  static var tools: UIViewController {
    let viewController = NavigationController(rootViewController: ToolsVC())
    viewController.tabBarItem = UITabBarItem(
      title: "Tools",
      image: .gearshape,
      selectedImage: .gearshapeFill
    )
    return viewController
  }

  static var about: UIViewController {
    let viewController = NavigationController(rootViewController: AboutVC())
    viewController.tabBarItem = UITabBarItem(
      title: "About",
      image: .infoCircle,
      selectedImage: .infoCircleFill
    )
    return viewController
  }
}
