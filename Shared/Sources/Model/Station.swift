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

struct SortedStations: Identifiable {
  var id: String

  var stations: [Station]

  init(id: String, stations: [Station]) {
    self.id = id
    self.stations = stations
  }
}

extension SortedStations: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: SortedStations, rhs: SortedStations) -> Bool {
    lhs.id == rhs.id
  }
}
