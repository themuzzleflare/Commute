import Foundation
import SwiftDate

extension Int {
  /// Seconds to hours, minutes, seconds.
  var intervalString: String {
    return self.seconds.timeInterval.toString {
      $0.unitsStyle = .abbreviated
      $0.allowedUnits = [.hour, .minute, .second]
    }
  }

  /// `UInt(self)`.
  var uInt: UInt {
    return UInt(self)
  }
}
