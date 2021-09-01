import Foundation

extension Double {
  var kilometres: Double {
    return Measurement(value: self, unit: UnitLength.meters).converted(to: .kilometers).value
  }

  var nsNumber: NSNumber {
    return NSNumber(value: self)
  }
}
