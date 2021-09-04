import Foundation
import UIKit

extension UIButton {
  /// A button for enabling location services.
  static var locationServicesButton: UIButton {
    let button: UIButton

    if #available(iOS 14.0, *) {
      button = UIButton(type: .roundedRect, primaryAction: .openSettings)
    } else {
      button = UIButton(type: .roundedRect)
      button.addAction {
        if UIApplication.shared.canOpenURL(.settingsApp) {
          UIApplication.shared.open(.settingsApp)
        }
      }
    }

    button.setAttributedTitle(
      NSAttributedString(
        text: "Enable Location Services",
        font: .newFrankRegular(size: UIFont.buttonFontSize),
        colour: .accentColor,
        alignment: .centreAligned
      ),
      for: .normal
    )

    return button
  }
}
