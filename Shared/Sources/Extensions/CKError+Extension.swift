import Foundation
import CloudKit

extension CKError {
  /// The custom title of the error.
  var title: String {
    switch self.code {
    case .internalError:
      return "Internal Error"
    case .partialFailure:
      return "Partial Error"
    case .networkUnavailable:
      return "Network Unavailable"
    case .networkFailure:
      return "Network Failure"
    case .badContainer:
      return "Bad Container"
    case .serviceUnavailable:
      return "Service Unavailable"
    case .requestRateLimited:
      return "Request Rate-Limited"
    case .missingEntitlement:
      return "Missing Entitlement"
    case .notAuthenticated:
      return "Not Authenticated"
    case .permissionFailure:
      return "Permission Failure"
    case .unknownItem:
      return "Unknown Item"
    case .invalidArguments:
      return "Invalid Arguments"
    case .resultsTruncated:
      return "Results Truncated"
    case .serverRecordChanged:
      return "Server Record Changed"
    case .serverRejectedRequest:
      return "Server Rejected Request"
    case .assetFileNotFound:
      return "Asset File Not Found"
    case .assetFileModified:
      return "Asset File Modified"
    case .incompatibleVersion:
      return "Incompatible Version"
    case .constraintViolation:
      return "Constraint Violation"
    case .operationCancelled:
      return "Operation Cancelled"
    case .changeTokenExpired:
      return "Change Token Expired"
    case .batchRequestFailed:
      return "Batch Request Failed"
    case .zoneBusy:
      return "Zone Busy"
    case .badDatabase:
      return "Bad Database"
    case .quotaExceeded:
      return "Quota Exceeded"
    case .zoneNotFound:
      return "Zone Not Found"
    case .limitExceeded:
      return "Limit Exceeded"
    case .userDeletedZone:
      return "User Deleted Zone"
    case .tooManyParticipants:
      return "Too Many Participants"
    case .alreadyShared:
      return "Already Shared"
    case .referenceViolation:
      return "Reference Violation"
    case .managedAccountRestricted:
      return "Managed Account Restricted"
    case .participantMayNeedVerification:
      return "Participant May Need Verification"
    case .serverResponseLost:
      return "Server Response Lost"
    case .assetNotAvailable:
      return "Asset Not Available"
    @unknown default:
      return "Error"
    }
  }

  /// The custom description of the error.
  var description: String {
    switch self.code {
    case .internalError:
      return "The CloudKit framework encountered an error."
    case .partialFailure:
      return "Some items failed, but the operation succeeded overall."
    case .networkUnavailable:
      return "Your network is unavailable."
    case .networkFailure:
      return "Your network is available, but CloudKit is inaccessible."
    case .badContainer:
      return "Un-provisioned or unauthorised container."
    case .serviceUnavailable:
      return "CloudKit is unavailable."
    case .requestRateLimited:
      return "The request was rate-limited—try again later."
    case .missingEntitlement:
      return "The app is missing a required entitlement."
    case .notAuthenticated:
      return "You are unauthenticated."
    case .permissionFailure:
      return "You don't have permission to perform this operation."
    case .unknownItem:
      return "The specified record doesn’t exist."
    case .invalidArguments:
      return self.localizedDescription
    case .resultsTruncated:
      return "The query’s results were truncated."
    case .serverRecordChanged:
      return "The record was rejected because the server’s version is different."
    case .serverRejectedRequest:
      return "The request was rejected by the server."
    case .assetFileNotFound:
      return "The asset file was not found."
    case .assetFileModified:
      return "The asset file content was modified while being saved."
    case .incompatibleVersion:
      return "The app version is less than the minimum allowed version."
    case .constraintViolation:
      return "The server rejected the request because there was a conflict with a unique field."
    case .operationCancelled:
      return "The operation was explicitly cancelled."
    case .changeTokenExpired:
      return "The change token is expired."
    case .batchRequestFailed:
      return "One of the items in this batch operation failed in a zone with atomic updates, so the entire batch was rejected."
    case .zoneBusy:
      return "The server is too busy to handle this zone operation. Try the operation again in a few seconds."
    case .badDatabase:
      return "The operation could not be completed on the given database."
    case .quotaExceeded:
      return "Saving this record would exceed quota."
    case .zoneNotFound:
      return "The specified zone does not exist on the server."
    case .limitExceeded:
      return "The request to the server was too large. Retry this request as a smaller batch."
    case .userDeletedZone:
      return "You deleted this zone."
    case .tooManyParticipants:
      return "The share cannot be saved because there are too many participants attached to it."
    case .alreadyShared:
      return "The record/share cannot be saved, doing so would cause a hierarchy of records to exist in multiple shares."
    case .referenceViolation:
      return "The target of this record's parent or share reference was not found."
    case .managedAccountRestricted:
      return "The request was rejected due to a managed account restriction."
    case .participantMayNeedVerification:
      return "The share metadata cannot be determined, because you are not a member of the share."
    case .serverResponseLost:
      return "The server received and processed this request, but the response was lost due to a network failure."
    case .assetNotAvailable:
      return "The file for this asset could not be accessed."
    @unknown default:
      return "An unknown error was encountered."
    }
  }
}
