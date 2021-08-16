import Foundation

struct TripRequestResponseJourneyLegStop: Codable, Identifiable {
  var id: String?
  var name: String?
  var disassembledName: String?
  var type: String?
  var parent: ParentLocation?
  var departureTimeEstimated: String?
  var departureTimePlanned: String?
  var arrivalTimeEstimated: String?
  var arrivalTimePlanned: String?
}
