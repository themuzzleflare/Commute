import Foundation
import CloudKit

extension CKContainer {
  static let commute = CKContainer(identifier: "iCloud.\(InfoPlist.cfBundleIdentifier)")
}
