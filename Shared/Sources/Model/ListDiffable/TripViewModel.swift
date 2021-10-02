import Foundation
import IGListKit

final class TripViewModel: NSObject {
  let id: String
  let name: String
  let fromStopId: String
  let toStopId: String
  
  init(id: String, name: String, fromStopId: String, toStopId: String) {
    self.id = id
    self.name = name
    self.fromStopId = fromStopId
    self.toStopId = toStopId
  }
  
  init(trip: Trip) {
    self.id = trip.id?.uuidString ?? UUID().uuidString
    self.name = trip.tripName
    self.fromStopId = trip.fromStopId ?? ""
    self.toStopId = trip.toStopId ?? ""
  }
}

extension TripViewModel: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObjectProtocol
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    if self === object { return true }
    guard let object = object as? TripViewModel else { return false }
    return self.name == object.name
  }
}
