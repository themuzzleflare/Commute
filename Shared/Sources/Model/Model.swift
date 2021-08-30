import Foundation
import UIKit

struct ModelFacade {
  static func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
  }
}
