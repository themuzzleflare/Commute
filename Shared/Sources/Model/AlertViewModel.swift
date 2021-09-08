import Foundation
import IGListKit

class AlertViewModel: ListDiffable {
  let header: String
  let activePeriod: String

  init(header: String, activePeriod: String) {
    self.header = header
    self.activePeriod = activePeriod
  }

  func diffIdentifier() -> NSObjectProtocol {
    return NSString(string: "\(header)-\(activePeriod)".trimmingCharacters(in: .whitespacesAndNewlines))
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? AlertViewModel else { return false }
    return self.header == object.header && self.activePeriod == object.activePeriod
  }
}
