import Foundation
import CloudKit

func permissionStatusDetail(for status: CKContainer_Application_PermissionStatus) -> EnumType {
  switch status {
  case .initialState:
    return EnumType(title: "Initial State", detail: "The app is yet to request the permission.")
  case .couldNotComplete:
    return EnumType(title: "Could Not Complete", detail: "An error that occurs while processing the permission request.")
  case .denied:
    return EnumType(title: "Denied", detail: "The user denies the permission.")
  case .granted:
    return EnumType(title: "Granted", detail: "The user grants the permission.")
  @unknown default:
    return EnumType(title: "Unknown", detail: "Unknown status")
  }
}
