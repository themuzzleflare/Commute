import Foundation

extension Double {
  func kilometres(from baseUnit: UnitLength) -> Double {
    return Measurement(value: self, unit: baseUnit).converted(to: .kilometers).value
  }
}
