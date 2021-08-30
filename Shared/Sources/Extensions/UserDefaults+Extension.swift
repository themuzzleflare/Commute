import Foundation

extension UserDefaults {
  /// A `UserDefaults` object for the `group.cloud.tavitian.commute` application group.
  static var commute: UserDefaults {
    return UserDefaults(suiteName: "group.\(ModelFacade.infoForKey("CFBundleIdentifier")!)") ?? .standard
  }

  var appVersion: String {
    return string(forKey: "appVersion") ?? "Unknown"
  }

  var appBuild: String {
    return string(forKey: "appBuild") ?? "Unknown"
  }
}
