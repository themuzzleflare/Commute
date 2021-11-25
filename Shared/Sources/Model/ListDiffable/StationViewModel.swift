import Foundation
import IGListKit
import CoreLocation

final class StationViewModel: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    if self === object { return true }
    guard let object = object as? StationViewModel else { return false }
    return self.id == object.id && self.type == object.type && self.distance == object.distance
  }
  
  let station: Station
  let type: StationSort
  let id: String
  let name: String
  let distance: CLLocation?
  
  init(station: Station, type: StationSort, id: String, name: String, distance: CLLocation?) {
    self.station = station
    self.type = type
    self.id = id
    self.name = name
    self.distance = distance
  }
}
