import Foundation

struct ParentLocation: Codable, Identifiable {
  var id: String?
  var name: String?
  var disassembledName: String?
  var type: String?
  var parent: GrandparentLocation?
}
