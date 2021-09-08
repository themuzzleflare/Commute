import Foundation

enum StationSort: Int, CaseIterable {
  /// By name.
  case byName = 0

  /// By distance.
  case byDistance = 1
}

extension StationSort {
  var title: String {
    switch self {
    case .byName:
      return "By Name"
    case .byDistance:
      return "By Distance"
    }
  }

  var shortTitle: String {
    switch self {
    case .byName:
      return "Name"
    case .byDistance:
      return "Distance"
    }
  }
}
