import Foundation

extension UserDefaults {
  /// A `UserDefaults` object, instantiated with the application group as the `suiteName`.
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
