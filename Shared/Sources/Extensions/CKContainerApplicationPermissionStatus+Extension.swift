import Foundation
import CloudKit

extension CKContainer_Application_PermissionStatus {
  /// The custom title of the permission status.
  var title: String {
    switch self {
    case .initialState:
      return "Initial State"
    case .couldNotComplete:
      return "Could Not Complete"
    case .denied:
      return "Denied"
    case .granted:
      return "Granted"
    @unknown default:
      return "Unknown"
    }
  }

  /// The custom description of the permission status.
  var description: String {
    switch self {
    case .initialState:
      return "The app is yet to request the permission."
    case .couldNotComplete:
      return "An error that occurs while processing the permission request."
    case .denied:
      return "The user denies the permission."
    case .granted:
      return "The user grants the permission."
    @unknown default:
      return "Unknown status"
    }
  }
}
