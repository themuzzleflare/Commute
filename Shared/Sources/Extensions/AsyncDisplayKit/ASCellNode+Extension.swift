import Foundation
import UIKit
import AsyncDisplayKit

extension ASCellNode {
  func select() {
    self.backgroundColor = .accentColor
  }

  func deselect() {
    UIView.animate(withDuration: 0.5, animations: {
      self.backgroundColor = .systemBackground
    })
  }

  func highlight() {
    self.backgroundColor = .accentColor
  }

  func unhighlight() {
    self.backgroundColor = .systemBackground
  }
}
