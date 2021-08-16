import Foundation
import CloudKit

struct Station: Identifiable {
  var id: CKRecord.ID
  var globalId: String
  var stopId: String
  var name: String
  var suburb: String
  var location: CLLocation
}

extension Station: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Station, rhs: Station) -> Bool {
    lhs.id == rhs.id
  }
}
