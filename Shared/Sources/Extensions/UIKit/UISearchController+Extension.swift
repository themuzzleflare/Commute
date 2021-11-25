import Foundation
import UIKit

extension UISearchController {
  static func tripsSearchController(_ delegate: UISearchBarDelegate) -> UISearchController {
    let searchController = UISearchController.stationsSearchController(delegate)
    searchController.searchBar.scopeButtonTitles = AddTripType.allCases.map {  $0.description }
    return searchController
  }
  
  static func stationsSearchController(_ delegate: UISearchBarDelegate) -> UISearchController {
    let searchController = UISearchController()
    searchController.searchBar.delegate = delegate
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.searchBarStyle = .minimal
    return searchController
  }
}
