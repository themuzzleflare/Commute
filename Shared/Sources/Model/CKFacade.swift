import Foundation
import CloudKit

struct CKFacade {
  static let container = CKContainer(identifier: "iCloud.\(infoForKey("CFBundleIdentifier")!)")
  static let database = container.publicCloudDatabase

  static func searchStation(cursor: CKQueryOperation.Cursor? = nil, inputStations: [Station]? = nil, searchString: String? = nil, currentLocation: CLLocation? = nil, exclude: Station? = nil, completion: @escaping (Result<[Station], CKError>) -> Void) {

    var stations = [Station]()

    if let inputStations = inputStations {
      stations.append(contentsOf: inputStations)
    }

    let operation: CKQueryOperation

    if let cursor = cursor {
      operation = CKQueryOperation(cursor: cursor)
    } else {
      let predicate: NSPredicate

      if let searchString = searchString {
        if let exclude = exclude {
          predicate = NSPredicate(format: "name BEGINSWITH %@ AND id != %@", searchString.capitalized, exclude.globalId)
        } else {
          predicate = NSPredicate(format: "name BEGINSWITH %@", searchString.capitalized)
        }
      } else {
        predicate = NSPredicate(value: true)
      }

      let query = CKQuery(recordType: "Stations", predicate: predicate)

      if let location = currentLocation {
        let locationSort = CKLocationSortDescriptor(key: "location", relativeLocation: location)

        query.sortDescriptors = [locationSort]
      }

      operation = CKQueryOperation(query: query)
    }

    operation.resultsLimit = 200
    operation.qualityOfService = .userInitiated

    operation.recordFetchedBlock = {
      (record) in
      let station = Station(
        id: record.recordID,
        globalId: record["id"] as! String,
        stopId: record["stopId"] as! String,
        name: record["name"] as! String,
        suburb: record["suburb"] as! String,
        location: record["location"] as! CLLocation
      )

      stations.append(station)
    }

    operation.queryCompletionBlock = {
      (cursor, operationError) in
      DispatchQueue.main.async {
        if let error = operationError {
          completion(.failure(error as! CKError))
        } else if let cursor = cursor {
          searchStation(
            cursor: cursor,
            inputStations: stations,
            completion: completion
          )
        } else {
          completion(.success(stations))
        }
      }
    }

    database.add(operation)
  }
}
