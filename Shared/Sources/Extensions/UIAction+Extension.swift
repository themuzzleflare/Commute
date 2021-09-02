import Foundation
import UIKit

extension UIAction {
  static var openSettings: UIAction {
    return UIAction(handler: { (_) in
      UIApplication.shared.open(.settingsApp)
    })
  }
}
