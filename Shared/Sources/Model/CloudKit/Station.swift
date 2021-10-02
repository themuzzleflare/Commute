import Foundation
import CloudKit
import IGListKit

final class Station: NSObject {
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

  init(id: CKRecord.ID, globalId: String, stopId: String, name: String, suburb: String, location: CLLocation) {
    self.id = id
    self.globalId = globalId
    self.stopId = stopId
    self.name = name
    self.suburb = suburb
    self.location = location
  }
}

extension Station: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? Station else { return false }
    return self.id == object.id
  }
}

extension Station {
  /// `station.name`, with occurrunces of "Station" removed.
  var shortName: String {
    return name.replacingOccurrences(of: " Station", with: "")
  }
}
