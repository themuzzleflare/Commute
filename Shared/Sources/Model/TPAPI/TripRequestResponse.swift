import Foundation

struct TripRequestResponse: Codable {
  var version: String?
  var journeys: [TripRequestResponseJourney]?
}
