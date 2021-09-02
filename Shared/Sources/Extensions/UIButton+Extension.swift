import Foundation
import UIKit

extension UIButton {
  static var locationServicesButton: UIButton {
    let button = UIButton(type: .roundedRect)
    button.setAttributedTitle(
      NSAttributedString(
        string: "Enable Location Services",
        font: .newFrankRegular(size: UIFont.buttonFontSize),
        colour: .accentColor,
        alignment: .centreAligned
      ),
      for: .normal
    )
    button.addAction {
      UIApplication.shared.open(.settingsApp)
    }
    return button
  }
}
