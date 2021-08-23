import Foundation
import CloudKit

func errorDetail(for error: CKError) -> EnumType {
  switch error.code {
  case .internalError:
    return EnumType(title: "Internal Error", detail: "The CloudKit framework encountered an error.")
  case .partialFailure:
    return EnumType(title: "Partial Error", detail: "Some items failed, but the operation succeeded overall.")
  case .networkUnavailable:
    return EnumType(title: "Network Unavailable", detail: "Your network is unavailable.")
  case .networkFailure:
    return EnumType(title: "Network Failure", detail: "Your network is available, but CloudKit is inaccessible.")
  case .badContainer:
    return EnumType(title: "Bad Container", detail: "Un-provisioned or unauthorised container.")
  case .serviceUnavailable:
    return EnumType(title: "Service Unavailable", detail: "CloudKit is unavailable.")
  case .requestRateLimited:
    return EnumType(title: "Request Rate-Limited", detail: "The request was rate-limited—try again later.")
  case .missingEntitlement:
    return EnumType(title: "Missing Entitlement", detail: "The app is missing a required entitlement.")
  case .notAuthenticated:
    return EnumType(title: "Not Authenticated", detail: "You are unauthenticated.")
  case .permissionFailure:
    return EnumType(title: "Permission Failure", detail: "You don't have permission to perform this operation.")
  case .unknownItem:
    return EnumType(title: "Unknown Item", detail: "The specified record doesn’t exist.")
  case .invalidArguments:
    return EnumType(title: "Invalid Arguments", detail: error.localizedDescription)
  case .resultsTruncated:
    return EnumType(title: "Results Truncated", detail: "The query’s results were truncated.")
  case .serverRecordChanged:
    return EnumType(title: "Server Record Changed", detail: "The record was rejected because the server’s version is different.")
  case .serverRejectedRequest:
    return EnumType(title: "Server Rejected Request", detail: "The request was rejected by the server.")
  case .assetFileNotFound:
    return EnumType(title: "Asset File Not Found", detail: "The asset file was not found.")
  case .assetFileModified:
    return EnumType(title: "Asset File Modified", detail: "The asset file content was modified while being saved.")
  case .incompatibleVersion:
    return EnumType(title: "Incompatible Version", detail: "The app version is less than the minimum allowed version.")
  case .constraintViolation:
    return EnumType(title: "Constraint Violation", detail: "The server rejected the request because there was a conflict with a unique field.")
  case .operationCancelled:
    return EnumType(title: "Operation Cancelled", detail: "The operation was explicitly cancelled.")
  case .changeTokenExpired:
    return EnumType(title: "Change Token Expired", detail: "The change token is expired.")
  case .batchRequestFailed:
    return EnumType(title: "Batch Request Failed", detail: "One of the items in this batch operation failed in a zone with atomic updates, so the entire batch was rejected.")
  case .zoneBusy:
    return EnumType(title: "Zone Busy", detail: "The server is too busy to handle this zone operation. Try the operation again in a few seconds.")
  case .badDatabase:
    return EnumType(title: "Bad Database", detail: "The operation could not be completed on the given database.")
  case .quotaExceeded:
    return EnumType(title: "Quota Exceeded", detail: "Saving this record would exceed quota.")
  case .zoneNotFound:
    return EnumType(title: "Zone Not Found", detail: "The specified zone does not exist on the server.")
  case .limitExceeded:
    return EnumType(title: "Limit Exceeded", detail: "The request to the server was too large. Retry this request as a smaller batch.")
  case .userDeletedZone:
    return EnumType(title: "User Deleted Zone", detail: "You deleted this zone.")
  case .tooManyParticipants:
    return EnumType(title: "Too Many Participants", detail: "The share cannot be saved because there are too many participants attached to it.")
  case .alreadyShared:
    return EnumType(title: "Already Shared", detail: "The record/share cannot be saved, doing so would cause a hierarchy of records to exist in multiple shares.")
  case .referenceViolation:
    return EnumType(title: "Reference Violation", detail: "The target of this record's parent or share reference was not found.")
  case .managedAccountRestricted:
    return EnumType(title: "Managed Account Restricted", detail: "The request was rejected due to a managed account restriction.")
  case .participantMayNeedVerification:
    return EnumType(title: "Participant May Need Verification", detail: "The share metadata cannot be determined, because you are not a member of the share.")
  case .serverResponseLost:
    return EnumType(title: "Server Response Lost", detail: "The server received and processed this request, but the response was lost due to a network failure.")
  case .assetNotAvailable:
    return EnumType(title: "Asset Not Available", detail: "The file for this asset could not be accessed.")
  @unknown default:
    return EnumType(title: "Error", detail: "An unknown error was encountered.")
  }
}
