import Foundation

struct TripRequestResponseJourneyLeg: Codable {
  var duration: Int?
  var isRealtimeControlled: Bool?
  var transportation: TripTransportation?
  var origin: TripRequestResponseJourneyLegStop?
  var destination: TripRequestResponseJourneyLegStop?
  var stopSequence: [TripRequestResponseJourneyLegStop]?
}
