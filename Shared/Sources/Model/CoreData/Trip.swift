import Foundation
import CoreData
import UIKit
import IGListKit

final class Trip: NSManagedObject {
  static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Trip] {
    let request: NSFetchRequest<Trip> = Trip.fetchRequest()

    request.sortDescriptors = [
      NSSortDescriptor(key: "dateAdded", ascending: false),
      NSSortDescriptor(key: "fromName", ascending: true),
      NSSortDescriptor(key: "toName", ascending: true)
    ]

    guard let tasks = try? AppDelegate.viewContext.fetch(request) else { return [] }
    return tasks
  }

  static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
    Trip.fetchAll(viewContext: viewContext).forEach { viewContext.delete($0) }
    try? viewContext.save()
  }
}

extension Trip {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
    return NSFetchRequest<Trip>(entityName: "Trip")
  }

  @NSManaged public var fromId: String
  @NSManaged public var fromName: String
  @NSManaged public var fromStopId: String
  @NSManaged public var toId: String
  @NSManaged public var toName: String
  @NSManaged public var toStopId: String
  @NSManaged public var dateAdded: Date
}

extension Trip: Identifiable {
  @NSManaged public var id: UUID
}

extension Trip: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return id as NSObject
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? Trip else { return false }
    return self.id == object.id
  }
}

extension Trip {
  /// `trip.fromName`, with occurrences of "Station" removed.
  var shortFromName: String {
    return fromName.replacingOccurrences(of: " Station", with: "")
  }

  /// `trip.toName`, with occurrences of "Station" removed.
  var shortToName: String {
    return toName.replacingOccurrences(of: " Station", with: "")
  }

  /// `trip.shortFromName` and `trip.shortToName`, separated by "to".
  var tripName: String {
    return "\(shortFromName) to \(shortToName)"
  }
}

extension Array where Element: Trip {
  func filtered(searchBar: UISearchBar) -> [Trip] {
    return self.filter { (trip) in
      switch searchBar.selectedScopeButtonIndex {
      case 0:
        return searchBar.text!.isEmpty || trip.fromName.localizedStandardContains(searchBar.text!)
      case 1:
        return searchBar.text!.isEmpty || trip.toName.localizedStandardContains(searchBar.text!)
      default:
        return searchBar.text!.isEmpty || trip.tripName.localizedStandardContains(searchBar.text!)
      }
    }
  }
}
