import Foundation
import UIKit

extension UIColor {
  static var accentColor: UIColor {
    return UIColor(named: "AccentColor") ?? UIColor(red: 0.925, green: 0.525, blue: 0.239, alpha: 1.000)
  }

  static var train: UIColor {
    return UIColor(named: "train") ?? UIColor(red: 0.911, green: 0.505, blue: 0.172, alpha: 1.000)
  }

  static var metro: UIColor {
    return UIColor(named: "metro") ?? UIColor(red: 0.000, green: 0.542, blue: 0.544, alpha: 1.000)
  }

  static var bus: UIColor {
    return UIColor(named: "bus") ?? UIColor(red: 0.000, green: 0.675, blue: 0.859, alpha: 1.000)
  }

  static var lightRail: UIColor {
    return UIColor(named: "lightRail") ?? UIColor(red: 0.859, green: 0.216, blue: 0.243, alpha: 1.000)
  }

  static var ferry: UIColor {
    return UIColor(named: "ferry") ?? UIColor(red: 0.333, green: 0.690, blue: 0.275, alpha: 1.000)
  }
}
