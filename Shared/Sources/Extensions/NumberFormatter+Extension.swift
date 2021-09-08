import Foundation

extension NumberFormatter {
  /// A `NumberFormatter` configured to a number style of decimal and min/max fraction digits of 2.
  static var twoDecimalPlaces: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }
}
