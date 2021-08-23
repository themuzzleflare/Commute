import Foundation
import CloudKit

func scopeDetail(for scope: CKDatabase.Scope) -> EnumType {
  switch scope {
  case .private:
    return EnumType(title: "Private", detail: "The private database.")
  case .public:
    return EnumType(title: "Public", detail: "The public database.")
  case .shared:
    return EnumType(title: "Shared", detail: "The shared database.")
  @unknown default:
      return EnumType(title: "Unknown", detail: "Unknown database")
  }
}
