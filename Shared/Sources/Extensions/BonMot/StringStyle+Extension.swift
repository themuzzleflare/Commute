import Foundation
import BonMot

typealias StringStyle = BonMot.StringStyle

extension StringStyle {
  static let commute = StringStyle(
    .font(.newFrankRegular(size: UIFont.labelFontSize)),
    .color(.label),
    .alignment(.left)
  )
  
  static let commuteBold = StringStyle(
    .font(.newFrankBold(size: UIFont.labelFontSize)),
    .color(.label),
    .alignment(.left)
  )
  
  static let stationDistance = StringStyle(
    .font(.newFrankRegular(size: UIFont.smallSystemFontSize)),
    .color(.secondaryLabel),
    .alignment(.left)
  )
}
