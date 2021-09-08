import Foundation
import CloudKit

struct CKFacade {
  static private let container = CKContainer.commute
  static private let publicDatabase = container.publicCloudDatabase
  static private let privateDatabase = container.privateCloudDatabase

  static func fetchAccountStatus(completion: @escaping (Result<CKAccountStatus, CKError>) -> Void) {
    container.accountStatus { (status, error) in
      if let error = error as? CKError {
        completion(.failure(error))
      } else {
        completion(.success(status))
      }
    }
  }

  static func checkPermissionStatus(completion: @escaping (Result<CKContainer_Application_PermissionStatus, CKError>) -> Void) {
    container.status(forApplicationPermission: .userDiscoverability) { (applicationPermissionStatus, error) in
      if let error = error as? CKError {
        completion(.failure(error))
      } else {
        completion(.success(applicationPermissionStatus))
      }
    }
  }

  static func requestDiscoverability(completion: @escaping (Result<CKContainer_Application_PermissionStatus, CKError>) -> Void) {
    container.requestApplicationPermission(.userDiscoverability) { (applicationPermissionStatus, error) in
      if let error = error as? CKError {
        completion(.failure(error))
      } else {
        completion(.success(applicationPermissionStatus))
      }
    }
  }

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
      } else {
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        query.sortDescriptors = [nameSort]
      }

      operation = CKQueryOperation(query: query)
    }

    operation.resultsLimit = 200
    operation.qualityOfService = .userInitiated

    operation.recordFetchedBlock = { (record) in
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

    operation.queryCompletionBlock = { (cursor, operationError) in
      if let error = operationError as? CKError {
        completion(.failure(error))
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

    publicDatabase.add(operation)
  }

  static func saveTripCreatedSubscription(completion: @escaping (Result<CKSubscription, CKError>) -> Void) {
    let notificationInfo = CKSubscription.NotificationInfo(
      alertLocalizationKey: "A new trip has been saved: %1$@ to %2$@",
      alertLocalizationArgs: [
        "CD_fromName",
        "CD_toName"
      ],
      title: "Trip Created",
      soundName: "cityrailBeep.wav"
    )

    let subscription = CKQuerySubscription(
      recordType: "CD_Trip",
      predicate: NSPredicate(value: true),
      subscriptionID: "tripCreated",
      options: .firesOnRecordCreation
    )

    subscription.zoneID = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone")
    subscription.notificationInfo = notificationInfo

    privateDatabase.save(subscription) { (subscription, error) in
      if let error = error as? CKError {
        completion(.failure(error))
      } else if let subscription = subscription {
        completion(.success(subscription))
      }
    }
  }

  static func saveTripDeletedSubscription(completion: @escaping (Result<CKSubscription, CKError>) -> Void) {
    let notificationInfo = CKSubscription.NotificationInfo(
      alertLocalizationKey: "A trip has been deleted: %1$@ to %2$@",
      alertLocalizationArgs: [
        "CD_fromName",
        "CD_toName"
      ],
      title: "Trip Deleted",
      soundName: "cityrailBeep.wav"
    )

    let subscription = CKQuerySubscription(
      recordType: "CD_Trip",
      predicate: NSPredicate(value: true),
      subscriptionID: "tripDeleted",
      options: .firesOnRecordDeletion
    )

    subscription.zoneID = CKRecordZone.ID(zoneName: "com.apple.coredata.cloudkit.zone")
    subscription.notificationInfo = notificationInfo

    privateDatabase.save(subscription) { (subscription, error) in
      if let error = error as? CKError {
        completion(.failure(error))
      } else if let subscription = subscription {
        completion(.success(subscription))
      }
    }
  }
}
