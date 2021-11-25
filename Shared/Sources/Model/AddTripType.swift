import Foundation

enum AddTripType: Int, CaseIterable {
  /// Origin.
  case origin = 0

  /// Destination.
  case destination = 1
}

extension AddTripType {
  var description: String {
    switch self {
    case .origin:
      return "Origin"
    case .destination:
      return "Destination"
    }
  }
}
