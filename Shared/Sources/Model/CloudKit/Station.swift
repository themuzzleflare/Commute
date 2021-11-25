import Foundation
import CloudKit
import IGListKit

struct Station {
  /// The `CKRecord.ID` associated with the record.
  let id: CKRecord.ID

  /// The `id` field.
  let globalId: String

  /// The `stopId` field.
  let stopId: String

  /// The `name` field.
  let name: String

  /// The `suburb` field.
  let suburb: String

  /// The `location` field.
  let location: CLLocation
}

extension Station {
  /// `station.name`, with occurrunces of "Station" removed.
  var shortName: String {
    return name.replacingOccurrences(of: " Station", with: "")
  }
}
