import Foundation
import SwiftDate

extension Int {
  var secondsToHoursMinutesSeconds: String {
    return self.seconds.timeInterval.toString {
      $0.unitsStyle = .abbreviated
    }
  }

  /// UInt(self).
  var uInt: UInt {
    return UInt(self)
  }
}
