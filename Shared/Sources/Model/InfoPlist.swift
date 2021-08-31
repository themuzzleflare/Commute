import Foundation

struct InfoPlist {
  static var cfBundleIdentifier: String {
    return (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String)?.replacingOccurrences(of: "\\", with: "") ?? ""
  }

  static var nsHumanReadableCopyright: String {
    return (Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String)?.replacingOccurrences(of: "\\", with: "") ?? ""
  }
}
