import Foundation
import CloudKit

struct Station: Identifiable {
  /// The `CKRecord.ID` associated with the record.
  var id: CKRecord.ID

  /// The `id` field.
  var globalId: String

  /// The `stopId` field.
  var stopId: String

  /// The `name` field.
  var name: String

  /// The `suburb` field.
  var suburb: String

  /// The `location` field.
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

extension Station {
  /// `name`, with occurrunces of "Station" removed.
  var shortName: String {
    return name.replacingOccurrences(of: " Station", with: "")
  }
}
