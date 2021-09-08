import Foundation

extension UserDefaults {
  /// A `UserDefaults` instance for the application group. Observations should be made on a stored variable of this value.
  static var commute: UserDefaults {
    return UserDefaults(suiteName: "group.\(InfoPlist.cfBundleIdentifier)") ?? .standard
  }

  /// The integer of the "stationSort" key.
  @objc dynamic var stationSort: Int {
    get {
      return integer(forKey: Keys.stationSort)
    }
    set {
      setValue(newValue, forKey: Keys.stationSort)
    }
  }

  /// The configured `StationSort` enumeration based on the integer of the "stationSort" key.
  var stationSortEnum: StationSort {
    get {
      return StationSort(rawValue: stationSort) ?? .byName
    }
    set {
      stationSort = newValue.rawValue
    }
  }

  /// The short version string of the application.
  var appVersion: String {
    return string(forKey: Keys.appVersion) ?? "Unknown"
  }

  /// The build number of the application.
  var appBuild: String {
    return string(forKey: Keys.appBuild) ?? "Unknown"
  }
}

extension UserDefaults {
  private enum Keys {
    static let stationSort = "stationSort"
    static let appVersion = "appVersion"
    static let appBuild = "appBuild"
  }
}
