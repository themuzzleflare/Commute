import Foundation
import UIKit

extension UIAlertAction {
  /// A `UIAlertAction` with the `title` "Dismiss" and the `style` `.default`.
  static var dismiss: UIAlertAction {
    return UIAlertAction(title: "Dismiss", style: .default)
  }

  /// A `UIAlertAction` with the `title` "Cancel" and the `style` `.cancel`.
  static var cancel: UIAlertAction {
    return UIAlertAction(title: "Cancel", style: .cancel)
  }
}
