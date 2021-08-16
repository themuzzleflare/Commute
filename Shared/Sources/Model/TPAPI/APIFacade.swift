import Foundation
import Alamofire
import SwiftDate

struct APIFacade {
  static let apiKey = ModelFacade.infoForKey("TPAPIKey")!

  static func fetchJourneys(origin: String, destination: String, completion: @escaping (Result<[TripRequestResponseJourney], AFError>) -> Void) {
    let headers: HTTPHeaders = [
      "Authorization": "apikey \(apiKey)"
    ]

    let urlParams = [
      "outputFormat": "rapidJSON",
      "coordOutputFormat": "EPSG:4326",
      "itdDate": itdDate(),
      "itdTime": itdTime(),
      "depArrMacro": "dep",
      "type_origin": "any",
      "name_origin": origin,
      "type_destination": "any",
      "name_destination": destination,
      "calcNumberOfTrips": "10",
      "excludedMeans": "checkbox",
      "exclMOT_4": "1",
      "exclMOT_5": "1",
      "exclMOT_7": "1",
      "exclMOT_9": "1",
      "exclMOT_11": "1"
    ]

    AF.request("https://api.transport.nsw.gov.au/v1/tp/trip", method: .get, parameters: urlParams, headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON {
        (response) in
        switch response.result {
        case .success:
          if let decodedResponse = try? JSONDecoder().decode(TripRequestResponse.self, from: response.data!) {
            completion(.success(decodedResponse.journeys!))
          } else {
            completion(.failure(AFError.sessionDeinitialized))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}

extension APIFacade {
  static func itdDate() -> String {
    let date = Date()
    return date.toFormat("yyyyMMdd")
  }

  static func itdTime() -> String {
    let date = Date()
    return date.toFormat("HHmm")
  }
}
