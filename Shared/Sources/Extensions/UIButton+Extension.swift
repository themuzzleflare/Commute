import Foundation
import UIKit

extension UIButton {
  static var locationServicesButton: UIButton {
    let button: UIButton

    if #available(iOS 14.0, *) {
      button = UIButton(type: .roundedRect, primaryAction: .openSettings)
    } else {
      button = UIButton(type: .roundedRect)
      button.addAction {
        UIApplication.shared.open(.settingsApp)
      }
    }

    button.setAttributedTitle(
      NSAttributedString(
        string: "Enable Location Services",
        font: .newFrankRegular(size: UIFont.buttonFontSize),
        colour: .accentColor,
        alignment: .centreAligned
      ),
      for: .normal
    )
    return button
  }
}
