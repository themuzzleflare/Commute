import Foundation
import UIKit

extension CGSize {
  static func cellNode(height: CGFloat) -> CGSize {
    return CGSize(width: .screenWidth, height: height)
  }

  static var separator: CGSize {
    return CGSize(width: .screenWidth, height: 0.5)
  }
}
