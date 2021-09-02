import Foundation

extension Int {
  var secondsToHoursMinutesSeconds: String {
    let (hours, minutes, seconds) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    var string = hours > 0 ? "\(hours) h" : ""
    string = minutes > 0 ? string + " \(minutes) min" : string
    string = seconds > 0 ? string + " \(seconds) sec" : string
    return string
  }

  /// UInt(self).
  var uInt: UInt {
    return UInt(self)
  }
}
