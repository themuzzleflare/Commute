import Foundation

extension UserDefaults {
  static var commute: UserDefaults {
    return UserDefaults(suiteName: "group.\(InfoPlist.cfBundleIdentifier)") ?? .standard
  }

  /// The short version string of the application.
  var appVersion: String {
    return string(forKey: "appVersion") ?? "Unknown"
  }

  /// The build number of the application.
  var appBuild: String {
    return string(forKey: "appBuild") ?? "Unknown"
  }
}
