import Foundation
import CloudKit

func accountStatusDetail(for status: CKAccountStatus) -> EnumType {
  switch status {
  case .couldNotDetermine:
    return EnumType(title: "Could Not Determine", detail: "CloudKit can’t determine the status of the user’s iCloud account.")
  case .available:
    return EnumType(title: "Available", detail: "The user’s iCloud account is available.")
  case .restricted:
    return EnumType(title: "Restricted", detail: "The system denies access to the user’s iCloud account.")
  case .noAccount:
    return EnumType(title: "No Account", detail: "The device doesn’t have an iCloud account.")
  @unknown default:
    return EnumType(title: "Unknown", detail: "Unknown status")
  }
}
