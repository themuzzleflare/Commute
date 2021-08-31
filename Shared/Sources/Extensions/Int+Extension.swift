import Foundation

extension Int {
  var secondsToHoursMinutesSecondsStr: String {
    let (hours, minutes, seconds) = secondsToHoursMinutesSeconds
    var str = hours > 0 ? "\(hours) h" : ""
    str = minutes > 0 ? str + " \(minutes) min" : str
    str = seconds > 0 ? str + " \(seconds) sec" : str
    return str
  }

  var secondsToHoursMinutesSeconds: (Int, Int, Int) {
    return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
  }
}
