import CloudKit
import UIKit
import IGListKit
import AsyncDisplayKit

final class AddTripVC: ASViewController {
  private var addTripType: AddTripType
  private var fromStation: Station?

  private let collectionNode = ASCollectionNode(collectionViewLayout: .flowLayout)

  private lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: StationSort.allCases.map { $0.title })
    segmentedControl.selectedSegmentIndex = sortSelection.rawValue
    segmentedControl.addTarget(self, action: #selector(changedSelection), for: .valueChanged)
    return segmentedControl
  }()

  private var byNameStations = [Station]() {
    didSet {
      noByNameStations = byNameStations.isEmpty
      if sortSelection == .byName { adapter.performUpdates(animated: true, completion: nil) }
    }
  }

  private var byDistanceStations = [Station]() {
    didSet {
      noByDistanceStations = byDistanceStations.isEmpty
      if sortSelection == .byDistance { adapter.performUpdates(animated: true, completion: nil) }
    }
  }
  
  private var byNameStationModels: [StationViewModel] {
    return byNameStations.map { (station) in
      return StationViewModel(station: station, type: .byName, id: station.globalId, name: station.name, distance: nil)
    }
  }
  
  private var byDistanceStationModels: [StationViewModel] {
    return byDistanceStations.map { (station) in
      return StationViewModel(station: station, type: .byDistance, id: station.globalId, name: station.name, distance: locationManager.location)
    }
  }

  private var noByNameStations: Bool = false
  private var noByDistanceStations: Bool = false

  private var byNameError: CKError?
  private var byDistanceError: CKError?

  private lazy var sortSelection: StationSort = StationSort(rawValue: CommuteApp.appDefaults.stationSort) ?? .byName {
    didSet {
      if CommuteApp.appDefaults.stationSort != sortSelection.rawValue { CommuteApp.appDefaults.stationSort = sortSelection.rawValue }
      if segmentedControl.selectedSegmentIndex != sortSelection.rawValue { segmentedControl.selectedSegmentIndex = sortSelection.rawValue }
      adapter.performUpdates(animated: true)
    }
  }

  private var stationSortObserver: NSKeyValueObservation?

  private lazy var searchController = UISearchController.stationsSearchController(self)

  init(type: AddTripType, station: Station? = nil) {
    self.addTripType = type
    self.fromStation = station
    super.init(node: collectionNode)
    adapter.setASDKCollectionNode(collectionNode)
    adapter.dataSource = self
  }

  deinit {
    removeObserver()
    print("deinit")
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureToolbar()
    configureCollectionNode()
    configureObserver()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchStations()
  }

  private func configureNavigation() {
    navigationItem.title = addTripType.description
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.leftBarButtonItem = addTripType == .origin ? UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close)) : nil
    definesPresentationContext = true
  }

  private func configureToolbar() {
    setToolbarItems([UIBarButtonItem(customView: segmentedControl)], animated: false)
    navigationController?.setToolbarHidden(false, animated: true)
  }

  private func configureCollectionNode() {
    collectionNode.view.showsVerticalScrollIndicator = false
  }

  private func configureObserver() {
    stationSortObserver = CommuteApp.appDefaults.observe(\.stationSort, options: .new) { [weak self] (_, change) in
      guard let weakSelf = self, let value = change.newValue, let stationSort = StationSort(rawValue: value) else { return }
      weakSelf.sortSelection = stationSort
    }
  }

  private func removeObserver() {
    stationSortObserver?.invalidate()
    stationSortObserver = nil
  }

  private func fetchStations() {
    CKFacade.searchStation(searchString: searchController.searchBar.text, exclude: fromStation) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.byNameError = nil
          self.byNameStations = stations
        case .failure(let error):
          self.byNameError = error
          self.byNameStations = []
          let alertController = UIAlertController.errorAlertWithDismissButton(error: error)
          self.present(alertController, animated: true)
        }
      }
    }

    CKFacade.searchStation(searchString: searchController.searchBar.text, currentLocation: locationManager.location, exclude: fromStation) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.byDistanceError = nil
          self.byDistanceStations = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? stations : []
        case .failure(let error):
          self.byDistanceError = error
          self.byDistanceStations = []
          let alertController = UIAlertController.errorAlertWithDismissButton(error: error)
          self.present(alertController, animated: true)
        }
      }
    }
  }

  @objc private func changedSelection() {
    if let stationSort = StationSort(rawValue: segmentedControl.selectedSegmentIndex) {
      sortSelection = stationSort
    }
  }

  @objc private func close() {
    navigationController?.dismiss(animated: true)
  }
}

extension AddTripVC: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    switch sortSelection {
    case .byName:
      return byNameStationModels
    case .byDistance:
      return byDistanceStationModels
    }
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return StationsSectionController(addTripType: addTripType, fromStation: fromStation)
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    switch sortSelection {
    case .byName:
      if byNameStations.isEmpty && byNameError == nil {
        if byNameStations.isEmpty && !noByNameStations {
          return .loadingView(frame: collectionNode.bounds)
        } else {
          return .noStationsOrResultsView(for: searchController, frame: collectionNode.bounds)
        }
      } else {
        if let error = byNameError {
          return .errorView(for: error, frame: collectionNode.bounds)
        } else {
          return nil
        }
      }
    case .byDistance:
      if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
        return .locationServicesView(frame: collectionNode.bounds)
      } else {
        if byDistanceStations.isEmpty && byDistanceError == nil {
          if byDistanceStations.isEmpty && !noByDistanceStations {
            return .loadingView(frame: collectionNode.bounds)
          } else {
            return .noStationsOrResultsView(for: searchController, frame: collectionNode.bounds)
          }
        } else {
          if let error = byDistanceError {
            return .errorView(for: error, frame: collectionNode.bounds)
          } else {
            return nil
          }
        }
      }
    }
  }
}

extension AddTripVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    fetchStations()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.clear()
      fetchStations()
    }
  }
}

extension AddTripVC {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    fetchStations()
  }
}
