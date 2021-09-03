import Foundation

extension DecodingError {
  /// The custom title of the error.
  var title: String {
    switch self {
    case .typeMismatch(_, _):
      return "Type Mismatch"
    case .valueNotFound(_, _):
      return "Value Not Found"
    case .keyNotFound(_, _):
      return "Key Not Found"
    case .dataCorrupted(_):
      return "Data Corrupted"
    @unknown default:
      return "Unknown"
    }
  }
}
