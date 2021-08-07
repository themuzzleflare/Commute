import Foundation

struct TripRequestResponse: Codable {
  var version: String?
  var journeys: [TripRequestResponseJourney]?
}

struct TripRequestResponseJourney: Codable {
  var rating: Int?
  var isAdditional: Bool?
  var legs: [TripRequestResponseJourneyLeg]?
}

struct TripRequestResponseJourneyLeg: Codable {
  var duration: Int?
  var isRealtimeControlled: Bool?
  var transportation: TripTransportation?
  var origin: TripRequestResponseJourneyLegStop?
  var destination: TripRequestResponseJourneyLegStop?
  var stopSequence: [TripRequestResponseJourneyLegStop]?
}

struct TripTransportation: Codable, Identifiable {
  var id: String?
  var name: String?
  var disassembledName: String?
  var number: String?
  var iconId: Int?
  var description: String?
}

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

struct ParentLocation: Codable, Identifiable {
  var id: String?
  var name: String?
  var disassembledName: String?
  var type: String?
  var parent: GrandparentLocation?
}

struct GrandparentLocation: Codable, Identifiable {
  var id: String?
  var name: String?
  var disassembledName: String?
  var type: String?
}
