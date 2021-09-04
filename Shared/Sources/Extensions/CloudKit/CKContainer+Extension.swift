import Foundation
import CloudKit

extension CKContainer {
  static var commute: CKContainer {
    return CKContainer(identifier: "iCloud.\(InfoPlist.cfBundleIdentifier)")
  }
}
