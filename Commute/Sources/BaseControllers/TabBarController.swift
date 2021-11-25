import UIKit
import AsyncDisplayKit

final class TabBarController: ASTabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  private func configure() {
    setViewControllers([.trips, .tools, .about], animated: false)
  }
}
