import Foundation

extension DecodingError {
  /// The custom title of the error.
  var title: String {
    switch self {
    case .typeMismatch:
      return "Type Mismatch"
    case .valueNotFound:
      return "Value Not Found"
    case .keyNotFound:
      return "Key Not Found"
    case .dataCorrupted:
      return "Data Corrupted"
    @unknown default:
      return "Unknown"
    }
  }
}
