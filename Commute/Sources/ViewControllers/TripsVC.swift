import UIKit
import IGListKit
import AsyncDisplayKit

final class TripsVC: ASDKViewController<ASTableNode> {
  private let tableNode = ASTableNode(style: .grouped)

  private var trips = [Trip]() {
    didSet {
      applySnapshot()
    }
  }

  private lazy var removeAllBarButtonItem = UIBarButtonItem(
    title: "Remove All",
    style: .plain,
    target: self,
    action: #selector(removeAllTrips)
  )

  private var oldFilteredTrips = [Trip]()

  private var filteredTrips: [Trip] {
    return trips.filtered(searchBar: searchController.searchBar)
  }

  private lazy var editBarButtonItem = editButtonItem

  private lazy var addBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: self,
    action: #selector(openAddTrip)
  )

  private lazy var searchController = UISearchController.tripsSearchController(self)

  override init() {
    super.init(node: tableNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObserver()
    configureToolbar()
    configureNavigation()
    configureTableNode()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchTrips()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setToolbarHidden(!isEditing, animated: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setToolbarHidden(true, animated: false)
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableNode.view.setEditing(editing, animated: animated)
    addBarButtonItem.isEnabled = !editing
    navigationController?.setToolbarHidden(!editing, animated: true)
  }

  private func configureObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshTrips),
      name: NSNotification.Name(rawValue: "NSPersistentStoreRemoteChangeNotification"),
      object: AppDelegate.persistentContainer.persistentStoreCoordinator
    )
  }

  private func configureToolbar() {
    setToolbarItems([removeAllBarButtonItem], animated: false)
  }

  private func configureNavigation() {
    navigationItem.title = "Trips"
    navigationItem.leftBarButtonItem = editBarButtonItem
    navigationItem.rightBarButtonItem = addBarButtonItem
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
  }

  private func applySnapshot() {
    DispatchQueue.main.async { [self] in
      if filteredTrips.isEmpty {
        if trips.isEmpty {
          if isEditing { setEditing(false, animated: true) }
          if editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = false }
          tableNode.view.backgroundView = .noTripsView(frame: tableNode.bounds)
        } else {
          tableNode.view.backgroundView = .noResultsView(frame: tableNode.bounds)
        }
      } else {
        if !editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = true }
        if tableNode.view.backgroundView != nil { tableNode.view.backgroundView = nil }
      }

      let results = ListDiffPaths(
        fromSection: 0,
        toSection: 0,
        oldArray: oldFilteredTrips,
        newArray: filteredTrips,
        option: .equality
      )

      let batchUpdates = {
        tableNode.deleteRows(at: results.deletes, with: .automatic)
        tableNode.insertRows(at: results.inserts, with: .automatic)
        tableNode.reloadRows(at: results.updates, with: .none)
      }

      tableNode.performBatchUpdates(batchUpdates, completion: { (_) in
        oldFilteredTrips = filteredTrips
      })
    }
  }

  private func fetchTrips() {
    DispatchQueue.main.async {
      self.trips = Trip.fetchAll()
    }
  }

  @objc private func refreshTrips() {
    fetchTrips()
  }

  @objc private func openAddTrip() {
    let viewController = UIViewController.fullscreenPresentation(NavigationController(rootViewController: AddTripOriginVC()))
    present(viewController, animated: true)
  }

  @objc private func removeAllTrips() {
    let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you'd like to remove all saved trips? This cannot be undone.", preferredStyle: .actionSheet)
    let confirmAction = UIAlertAction(title: "Remove All", style: .destructive, handler: { (_) in
      Trip.deleteAll()
    })
    alertController.addAction(confirmAction)
    alertController.addAction(.cancel)
    present(alertController, animated: true)
  }
}

extension TripsVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return filteredTrips.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let trip = filteredTrips[indexPath.row]

    return {
      ASTextCellNode(string: trip.tripName, accessoryType: .disclosureIndicator)
    }
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let trip = filteredTrips[indexPath.row]

    switch editingStyle {
    case .delete:
      AppDelegate.viewContext.delete(trip)
      do {
        try AppDelegate.viewContext.save()
      } catch {
        DispatchQueue.main.async {
          let alertController = UIAlertController.alertWithDismissButton(title: "Error", message: error.localizedDescription)
          self.present(alertController, animated: true)
        }
      }
    default:
      break
    }
  }
}

extension TripsVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let trip = filteredTrips[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    navigationController?.pushViewController(TripDetailVC(trip: trip), animated: true)
  }
}

extension TripsVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    applySnapshot()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.clear()
      applySnapshot()
    }
  }

  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    if !searchBar.text!.isEmpty {
      applySnapshot()
    }
  }
}
