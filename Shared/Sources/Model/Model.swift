import Foundation
import UIKit

struct ModelFacade {
  static var pLeftStyle: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .left
    return ps
  }

  static var pRightStyle: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .right
    return ps
  }

  static var pCentreStyle: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .center
    return ps
  }

  static func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
  }
}
