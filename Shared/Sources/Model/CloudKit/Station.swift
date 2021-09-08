import Foundation
import CloudKit
import IGListKit

class Station: Identifiable {
  /// The `CKRecord.ID` associated with the record.
  var id: CKRecord.ID

  /// The `id` field.
  var globalId: String

  /// The `stopId` field.
  var stopId: String

  /// The `name` field.
  @StationName var name: String

  /// The `suburb` field.
  var suburb: String

  /// The `location` field.
  var location: CLLocation

  init(id: CKRecord.ID, globalId: String, stopId: String, name: String, suburb: String, location: CLLocation) {
    self.id = id
    self.globalId = globalId
    self.stopId = stopId
    self.name = name
    self.suburb = suburb
    self.location = location
  }
}

extension Station: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Station, rhs: Station) -> Bool {
    lhs.id == rhs.id
  }
}

extension Station: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObject
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
