import Foundation
import CoreData

final class Trip: NSManagedObject {
  static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Trip] {
    let request: NSFetchRequest<Trip> = Trip.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "fromName", ascending: true)]
    guard let tasks = try? AppDelegate.viewContext.fetch(request) else { return [] }
    return tasks
  }

  static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
    Trip.fetchAll(viewContext: viewContext).forEach({ viewContext.delete($0) })
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

}

extension Trip: Identifiable {
  @NSManaged public var id: UUID
}
