import Foundation

extension Double {
  var kilometres: Double {
    return Measurement(value: self, unit: UnitLength.meters).converted(to: .kilometers).value
  }

  /// `NSNumber(value: self)`.
  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }
}
