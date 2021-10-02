import Foundation
import CoreData
import UIKit

extension Trip {
  static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Trip] {
    let request: NSFetchRequest<Trip> = Trip.fetchRequest()
    
    request.sortDescriptors = [
      NSSortDescriptor(key: "dateAdded", ascending: false),
      NSSortDescriptor(key: "fromName", ascending: true),
      NSSortDescriptor(key: "toName", ascending: true)
    ]
    
    guard let tasks = try? viewContext.fetch(request) else { return [] }
    return tasks
  }
  
  static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
    Trip.fetchAll(viewContext: viewContext).forEach { viewContext.delete($0) }
    try? viewContext.save()
  }
  
    /// `trip.fromName`, with occurrences of "Station" removed.
  var shortFromName: String {
    return fromName?.replacingOccurrences(of: " Station", with: "") ?? ""
  }
  
    /// `trip.toName`, with occurrences of "Station" removed.
  var shortToName: String {
    return toName?.replacingOccurrences(of: " Station", with: "") ?? ""
  }
  
    /// `trip.shortFromName` and `trip.shortToName`, separated by "to".
  var tripName: String {
    return "\(shortFromName) to \(shortToName)"
  }
  
  var viewModel: TripViewModel {
    return TripViewModel(trip: self)
  }
}

extension Array where Element: Trip {
  func filtered(searchBar: UISearchBar) -> [Trip] {
    return self.filter { (trip) in
      switch searchBar.selectedScopeButtonIndex {
      case 0:
        return searchBar.text!.isEmpty || trip.fromName!.localizedStandardContains(searchBar.text!)
      case 1:
        return searchBar.text!.isEmpty || trip.toName!.localizedStandardContains(searchBar.text!)
      default:
        return searchBar.text!.isEmpty || trip.tripName.localizedStandardContains(searchBar.text!)
      }
    }
  }
  
  var viewModels: [TripViewModel] {
    return self.map { (trip) in
      return trip.viewModel
    }
  }
}
