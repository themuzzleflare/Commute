import Foundation
import UIKit

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
