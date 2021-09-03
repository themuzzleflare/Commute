import Foundation

struct SortedStations: Identifiable {
  /// The letter by which the stations are sorted.
  var id: String

  /// The sorted stations.
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
