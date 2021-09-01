import Foundation
import UIKit

extension NSParagraphStyle {
  /// A left-aligned paragraph style.
  static var leftAligned: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .left
    return ps
  }

  /// A centre-aligned paragraph style.
  static var centreAligned: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .center
    return ps
  }

  /// A right-aligned paragraph style.
  static var rightAligned: NSParagraphStyle {
    let ps = NSMutableParagraphStyle()
    ps.alignment = .right
    return ps
  }
}
