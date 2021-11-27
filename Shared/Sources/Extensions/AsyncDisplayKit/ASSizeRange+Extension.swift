import Foundation
import UIKit
import AsyncDisplayKit

extension ASSizeRange {
  static func cellNode(minHeight: CGFloat, maxHeight: CGFloat) -> ASSizeRange {
    return ASSizeRange(min: .cellNode(height: minHeight), max: .cellNode(height: maxHeight))
  }

  static let separator = ASSizeRange(min: .separator, max: .separator)
}
