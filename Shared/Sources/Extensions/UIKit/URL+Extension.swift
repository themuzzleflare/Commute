import Foundation
import UIKit

extension URL {
  static var settingsBundle: URL {
    return Bundle.main.url(forResource: "Settings", withExtension: "bundle")!
  }

  static var sydneyRailNetworkPDF: URL {
    return Bundle.main.url(forResource: "SydneyRailNetwork", withExtension: "pdf")!
  }

  static var settingsApp: URL {
    return URL(string: UIApplication.openSettingsURLString)!
  }
}
