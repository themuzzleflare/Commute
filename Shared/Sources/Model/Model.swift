import Foundation
import UIKit

var pLeftStyle: NSParagraphStyle {
  let ps = NSMutableParagraphStyle()
  ps.alignment = .left
  return ps
}

var pRightStyle: NSParagraphStyle {
  let ps = NSMutableParagraphStyle()
  ps.alignment = .right
  return ps
}

var pCentreStyle: NSParagraphStyle {
  let ps = NSMutableParagraphStyle()
  ps.alignment = .center
  return ps
}

func infoForKey(_ key: String) -> String? {
  return (Bundle.main.infoDictionary?[key] as? String)?
    .replacingOccurrences(of: "\\", with: "")
}
