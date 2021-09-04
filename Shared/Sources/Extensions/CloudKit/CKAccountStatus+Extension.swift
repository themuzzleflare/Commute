import Foundation
import CloudKit

extension CKAccountStatus {
  /// The custom title of the account status.
  var title: String {
    switch self {
    case .couldNotDetermine:
      return "Could Not Determine"
    case .available:
      return "Available"
    case .restricted:
      return "Restricted"
    case .noAccount:
      return "No Account"
    @unknown default:
      return "Unknown"
    }
  }

  /// The custom description of the account status.
  var description: String {
    switch self {
    case .couldNotDetermine:
      return "CloudKit can’t determine the status of the user’s iCloud account."
    case .available:
      return "The user’s iCloud account is available."
    case .restricted:
      return "The system denies access to the user’s iCloud account."
    case .noAccount:
      return "The device doesn’t have an iCloud account."
    @unknown default:
      return "Unknown status."
    }
  }
}
