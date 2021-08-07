import Foundation

let appDefaults = UserDefaults(suiteName: "group.\(infoForKey("CFBundleIdentifier")!)") ?? .standard

extension UserDefaults {
  var appVersion: String { return string(forKey: "appVersion") ?? "Unknown" }
  var appBuild: String { return string(forKey: "appBuild") ?? "Unknown" }
}
