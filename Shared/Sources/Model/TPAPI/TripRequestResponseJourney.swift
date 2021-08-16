import Foundation

struct TripRequestResponseJourney: Codable {
  var rating: Int?
  var isAdditional: Bool?
  var legs: [TripRequestResponseJourneyLeg]?
}
