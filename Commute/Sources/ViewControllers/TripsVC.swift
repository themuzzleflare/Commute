import UIKit
import IGListKit
import AsyncDisplayKit

final class TripsVC: ASViewController {
  private let collectionNode = ASCollectionNode(collectionViewLayout: .flowLayout)

  private lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  private var trips = [Trip]() {
    didSet {
      adapter.performUpdates(animated: true)
    }
  }

  private lazy var searchController = UISearchController.tripsSearchController(self)

  private var filteredTrips: [Trip] {
    return trips.filtered(searchBar: searchController.searchBar)
  }

  private lazy var removeAllBarButtonItem = UIBarButtonItem(
    title: "Remove All",
    style: .plain,
    target: self,
    action: #selector(removeAllTrips)
  )

  private lazy var editBarButtonItem = editButtonItem

  private lazy var addBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: self,
    action: #selector(openAddTrip)
  )

  override init() {
    super.init(node: collectionNode)
    adapter.setASDKCollectionNode(collectionNode)
    adapter.dataSource = self
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureObservers()
    configureToolbar()
    configureNavigation()
    configureCollectionNode()
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
    addBarButtonItem.isEnabled = !editing
    navigationController?.setToolbarHidden(!editing, animated: true)
  }

  private func configureObservers() {
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

  private func configureCollectionNode() {
    collectionNode.view.showsVerticalScrollIndicator = false
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
    let viewController = UIViewController.fullscreenPresentation(NavigationController(rootViewController: AddTripVC(type: .origin)))
    present(viewController, animated: true)
  }

  @objc private func removeAllTrips() {
    let alertController = UIAlertController.removeAllTripsConfirmation
    present(alertController, animated: true)
  }
}

extension TripsVC: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return filteredTrips.viewModels
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return TripsSectionController()
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    if filteredTrips.isEmpty {
      if trips.isEmpty {
        if isEditing { setEditing(false, animated: true) }
        if editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = false }
        return .noTripsView(frame: collectionNode.bounds)
      } else {
        return .noResultsView(frame: collectionNode.bounds)
      }
    } else {
      if !editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = true }
      return nil
    }
  }
}

extension TripsVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    adapter.performUpdates(animated: true)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.clear()
      adapter.performUpdates(animated: true)
    }
  }

  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    if !searchBar.text!.isEmpty {
      adapter.performUpdates(animated: true)
    }
  }
}
