import Foundation
import UIKit

extension UIImage {
  static var appLogo: UIImage {
    return UIImage(named: "appLogo")!
  }

  static var trainIcon: UIImage {
    return UIImage(named: "trainIcon")!
  }

  static var metroIcon: UIImage {
    return UIImage(named: "metroIcon")!
  }

  static var busIcon: UIImage {
    return UIImage(named: "busIcon")!
  }

  static var lightRailIcon: UIImage {
    return UIImage(named: "lightRailIcon")!
  }

  static var ferryIcon: UIImage {
    return UIImage(named: "ferryIcon")!
  }

  static var tram: UIImage {
    return UIImage(systemName: "tram") ?? UIImage(systemName: "tram.fill")!
  }

  static var tramFill: UIImage {
    return UIImage(systemName: "tram.fill")!
  }

  static var location: UIImage {
    return UIImage(systemName: "location")!
  }

  static var locationFill: UIImage {
    return UIImage(systemName: "location.fill")!
  }

  static var gearshape: UIImage {
    return UIImage(systemName: "gear")!
  }

  static var gearshapeFill: UIImage {
    return UIImage(systemName: "gear")!
  }

  static var infoCircle: UIImage {
    return UIImage(systemName: "info.circle")!
  }

  static var infoCircleFill: UIImage {
    return UIImage(systemName: "info.circle.fill")!
  }

  static var gear: UIImage {
    return UIImage(systemName: "gear")!
  }

  static var trash: UIImage {
    return UIImage(systemName: "trash")!
  }

  static var trashFill: UIImage {
    return UIImage(systemName: "trash.fill")!
  }
}
