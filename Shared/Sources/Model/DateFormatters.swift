import Foundation

func secondsToHoursMinutesSecondsStr(seconds: Int) -> String {
  let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds)
  var str = hours > 0 ? "\(hours) h" : ""
  str = minutes > 0 ? str + " \(minutes) min" : str
  str = seconds > 0 ? str + " \(seconds) sec" : str
  return str
}

func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
  return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}
