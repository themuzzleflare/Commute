import Foundation
import UIKit

extension UIAction {
  static var openSettings: UIAction {
    return UIAction(handler: { (_) in
      if UIApplication.shared.canOpenURL(.settingsApp) {
        UIApplication.shared.open(.settingsApp)
      }
    })
  }
}
