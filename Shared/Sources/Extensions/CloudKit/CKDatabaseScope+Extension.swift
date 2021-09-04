import Foundation
import CloudKit

extension CKDatabase.Scope {
  /// The custom title of the database scope.
  var title: String {
    switch self {
    case .private:
      return "Private"
    case .public:
      return "Public"
    case .shared:
      return "Shared"
    @unknown default:
      return "Unknown"
    }
  }

  /// The custom description of the database scope.
  var description: String {
    switch self {
    case .private:
      return "The private database."
    case .public:
      return "The public database."
    case .shared:
      return "The shared database."
    @unknown default:
      return "Unknown database."
    }
  }
}
