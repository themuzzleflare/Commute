import Foundation
import CloudKit
import UIKit

extension UIAlertController {
  static func alertWithDismissButton(title: String, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(.dismiss)
    return alertController
  }

  static func errorAlertWithDismissButton(error: CKError) -> UIAlertController {
    let alertController = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
    alertController.addAction(.dismiss)
    return alertController
  }
}
