import Foundation
import IGListKit
import CoreLocation

final class StationViewModel: ListDiffable {
  let station: Station
  let type: StationSort
  let id: String
  let name: String
  let distance: String
  
  init(station: Station, type: StationSort, id: String, name: String, distance: String) {
    self.station = station
    self.type = type
    self.id = id
    self.name = name
    self.distance = distance
  }
  
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? StationViewModel else { return false }
    return self.type == object.type
  }
}
