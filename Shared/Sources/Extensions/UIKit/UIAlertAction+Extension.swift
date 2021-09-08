import Foundation
import UIKit

extension UIAlertAction {
  /// A `UIAlertAction` with the `title` "Dismiss" and the `style` `.default`.
  static var dismiss: UIAlertAction {
    return UIAlertAction(title: "Dismiss", style: .default)
  }

  /// Cancel action that pops the current view controller from the navigation stack.
  static func dismissAndPop(_ navigationController: UINavigationController?) -> UIAlertAction {
    return UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
      navigationController?.popViewController(animated: true)
    })
  }

  /// A `UIAlertAction` with the `title` "Cancel" and the `style` `.cancel`.
  static var cancel: UIAlertAction {
    return UIAlertAction(title: "Cancel", style: .cancel)
  }

  static var removeAllTrips: UIAlertAction {
    return UIAlertAction(title: "Remove All", style: .destructive, handler: { (_) in
      Trip.deleteAll()
    })
  }
}
