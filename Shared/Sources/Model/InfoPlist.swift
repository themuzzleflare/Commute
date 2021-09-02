import Foundation

struct InfoPlist {
  static var cfBundleIdentifier: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
  }

  static var nsHumanReadableCopyright: String {
    return Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
  }

  static var mglMapboxAccessToken: String {
    return Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as? String ?? ""
  }
}
