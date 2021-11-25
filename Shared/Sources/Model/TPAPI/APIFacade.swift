import Foundation
import Alamofire
import TfNSW
import SwiftDate

struct APIFacade {
  static private let jsonDecoder = JSONDecoder()

  /**
   Retrieve a list of suggested transportation journeys based on the provided origin and destination.

   - parameters:
      - from: The `id` or `stopId` of the starting stop.
      - to: The `id` or `stopId` of the finishing stop.
   - returns: An array of `TripRequestResponseJourney` objects.
   - throws: An `Error` object.

   */

  static func fetchJourneys(from origin: String, to destination: String, completion: @escaping (Result<[TripRequestResponseJourney], Error>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json")
    ]

    let urlParams: Parameters = [
      "origin": origin,
      "destination": destination
    ]

    AF.request("https://api.commute.tavitian.cloud/trips", method: .get, parameters: urlParams, headers: headers).responseDecodable(of: TripRequestResponse.self) { (response) in
      switch response.result {
      case let .success(data):
        completion(.success(data.journeys!))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  static func fetchTrackworkAlerts(completion: @escaping (Result<TransitRealtime_FeedMessage, Error>) -> Void) {
    let headers: HTTPHeaders = [
      .accept("application/json")
    ]

    AF.request("https://api.commute.tavitian.cloud/alerts/trackwork", method: .get, headers: headers).responseJSON { (response) in
      switch response.result {
      case .success:
        do {
          let feed = try TransitRealtime_FeedMessage(jsonUTF8Data: response.data!)
          completion(.success(feed))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

extension APIFacade {
  static private var itdDate: String {
    return Date().toFormat("yyyyMMdd")
  }

  static private var itdTime: String {
    return Date().toFormat("HHmm")
  }
}
