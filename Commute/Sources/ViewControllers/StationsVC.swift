import CoreData
import CloudKit
import UIKit
import IGListKit
import AsyncDisplayKit

final class StationsVC: ASViewController {
  private let tableNode = ASTableNode(style: .grouped)

  private var oldStations = [Station]()

  private var stations = [Station]() {
    didSet {
      applySnapshot()
    }
  }

  private var byNameStations = [Station]() {
    didSet {
      if sortSelection == .byName {
        stations = byNameStations
      }
    }
  }

  private var byDistanceStations = [Station]() {
    didSet {
      if sortSelection == .byDistance {
        stations = byDistanceStations
      }
    }
  }

  private var noStations: Bool = false

  private var error: CKError?

  private var sortSelection: StationSort = .byName {
    didSet {
      switch sortSelection {
      case .byName:
        stations = byNameStations
      case .byDistance:
        stations = byDistanceStations
      }
      tableNode.reloadData()
    }
  }

  private lazy var searchController = UISearchController.stationsSearchController(self)

  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: StationSort.allCases.map { $0.title })
    segmentedControl.selectedSegmentIndex = sortSelection.rawValue
    segmentedControl.addTarget(self, action: #selector(changedSelection(_:)), for: .valueChanged)
    return segmentedControl
  }()

  override init() {
    super.init(node: tableNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureToolbar()
    configureTableNode()
    applySnapshot(override: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchStations()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setToolbarHidden(false, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: false)
  }

  private func configureNavigation() {
    navigationItem.title = "Stations"
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    if #available(iOS 14.0, *) {
      navigationItem.backButtonDisplayMode = .minimal
    } else {
      navigationItem.backButtonTitle = ""
    }
    definesPresentationContext = true
  }

  private func configureToolbar() {
    setToolbarItems([UIBarButtonItem(customView: segmentedControl)], animated: false)
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
  }

  private func applySnapshot(override: Bool = false) {
    DispatchQueue.main.async { [self] in
      let results = ListDiffPaths(
        fromSection: 0,
        toSection: 0,
        oldArray: oldStations,
        newArray: stations,
        option: .equality
      ).forBatchUpdates()

      if results.hasChanges || override {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
          tableNode.view.backgroundView = .locationServicesView(frame: tableNode.bounds)
        } else {
          if stations.isEmpty && error == nil {
            if stations.isEmpty && !noStations {
              tableNode.view.backgroundView = .loadingView(frame: tableNode.bounds)
            } else {
              tableNode.view.backgroundView = .noStationsOrResultsView(for: searchController, frame: tableNode.bounds)
            }
          } else {
            if let error = error {
              tableNode.view.backgroundView = .errorView(for: error, frame: tableNode.bounds)
            } else {
              if tableNode.view.backgroundView != nil { tableNode.view.backgroundView = nil }
            }
          }
        }

        let batchUpdates = {
          tableNode.deleteRows(at: results.deletes, with: .middle)
          tableNode.insertRows(at: results.inserts, with: .middle)
          results.moves.forEach { tableNode.moveRow(at: $0.from, to: $0.to) }
          tableNode.reloadRows(at: results.updates, with: .none)
        }

        tableNode.performBatchUpdates(batchUpdates, completion: { (_) in
          oldStations = stations
        })
      }
    }
  }

  private func fetchStations() {
    CKFacade.searchStation(searchString: searchController.searchBar.text) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.error = nil
          self.byNameStations = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? stations : []
        case .failure(let error):
          self.error = error
          self.byNameStations = []
          let alertController = UIAlertController.errorAlertWithDismissButton(error: error)
          self.present(alertController, animated: true)
        }
      }
    }

    CKFacade.searchStation(searchString: searchController.searchBar.text, currentLocation: locationManager.location) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.error = nil
          self.byDistanceStations = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? stations : []
        case .failure(let error):
          self.error = error
          self.byDistanceStations = []
          let alertController = UIAlertController.errorAlertWithDismissButton(error: error)
          self.present(alertController, animated: true)
        }
      }
    }
  }

  @objc private func changedSelection(_ segmentedControl: UISegmentedControl) {
    sortSelection = StationSort(rawValue: segmentedControl.selectedSegmentIndex)!
  }
}

extension StationsVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return stations.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let station = stations[indexPath.row]

    return {
      StationByDistanceCellNode(station: station, relativeLocation: self.locationManager.location ?? CLLocation())
    }
  }
}

extension StationsVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let station = stations[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    navigationController?.pushViewController(StationDetailVC(station: station), animated: true)
  }
}

extension StationsVC: UISearchBarDelegate {
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

extension StationsVC {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    fetchStations()
  }
}
