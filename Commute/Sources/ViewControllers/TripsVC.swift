import UIKit
import AsyncDisplayKit
import SnapKit
import IGListKit

final class TripsVC: ASViewController {
  private let tableNode = ASTableNode(style: .insetGrouped)
  
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
  
  private var filteredTrips: [Trip] {
    return trips.filter { (trip) in
      switch searchController.searchBar.selectedScopeButtonIndex {
      case 0:
        return searchController.searchBar.text!.isEmpty || trip.fromName!.localizedStandardContains(searchController.searchBar.text!)
      case 1:
        return searchController.searchBar.text!.isEmpty || trip.toName!.localizedStandardContains(searchController.searchBar.text!)
      default:
        return searchController.searchBar.text!.isEmpty || trip.fromName!.localizedStandardContains(searchController.searchBar.text!)
      }
    }
  }
  
  private var oldTripViewModels = [TripViewModel]()
  
  private lazy var editBarButtonItem = editButtonItem
  
  private lazy var addBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .add,
    target: self,
    action: #selector(openAddTrip)
  )
  
  private lazy var searchController: UISearchController = {
    let sc = UISearchController()
    sc.searchBar.delegate = self
    sc.obscuresBackgroundDuringPresentation = false
    sc.searchBar.searchBarStyle = .minimal
    sc.searchBar.scopeButtonTitles = ["Origin", "Destination"]
    return sc
  }()
  
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
    applySnapshot(override: true)
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
  
  private func applySnapshot(override: Bool = false) {
    let result = ListDiffPaths(
      fromSection: 0,
      toSection: 0,
      oldArray: oldTripViewModels,
      newArray: filteredTrips.viewModels,
      option: .equality
    ).forBatchUpdates()
    
    if filteredTrips.isEmpty {
      if trips.isEmpty {
        if isEditing { setEditing(false, animated: true) }
        if editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = false }
        tableNode.view.backgroundView = {
          let view = UIView(frame: tableNode.bounds)
          let titleLabel = UILabel.backgroundLabelTitle(text: "No Trips")
          let descriptionLabel = UILabel.backgroundLabelDescription(text: "To get started, tap the plus button to add a trip.")
          let stackView = UIStackView.backgroundStack(for: [titleLabel, descriptionLabel])
          view.addSubview(stackView)
          stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.center.equalToSuperview()
          }
          return view
        }()
      } else {
        tableNode.view.backgroundView = {
          let view = UIView(frame: tableNode.bounds)
          let titleLabel = UILabel.backgroundLabelTitle(text: "No Results")
          view.addSubview(titleLabel)
          titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
          }
          return view
        }()
      }
    } else {
      if !editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = true }
      if tableNode.view.backgroundView != nil { tableNode.view.backgroundView = nil }
    }
    
    let batchUpdates = { [self] in
      tableNode.deleteRows(at: result.deletes, with: .fade)
      tableNode.insertRows(at: result.inserts, with: .fade)
      result.moves.forEach { tableNode.moveRow(at: $0.from, to: $0.to) }
      tableNode.reloadRows(at: result.updates, with: .fade)
      oldTripViewModels = filteredTrips.viewModels
    }
    
    tableNode.performBatchUpdates(batchUpdates)
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
    let vc = NavigationController(rootViewController: AddTripVC(type: .origin, station: nil))
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
  
  @objc private func removeAllTrips() {
    let ac = UIAlertController(title: "Confirmation", message: "Are you sure you'd like to remove all saved trips? This cannot be undone.", preferredStyle: .actionSheet)
    let confirmAction = UIAlertAction(title: "Remove All", style: .destructive, handler: { (_) in
      Trip.deleteAll()
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(confirmAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }
}

extension TripsVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return filteredTrips.count
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let trip = filteredTrips.viewModels[indexPath.row]
    return {
      return TripCellNode(trip: trip)
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let trip = filteredTrips[indexPath.row]
    
    switch editingStyle {
    case .delete:
      AppDelegate.viewContext.delete(trip)
      
      do {
        try AppDelegate.viewContext.save()
        fetchTrips()
      } catch {
        DispatchQueue.main.async {
          let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Dismiss", style: .default)
          ac.addAction(cancelAction)
          self.present(ac, animated: true)
        }
      }
    default:
      break
    }
  }
}

extension TripsVC: ASTableDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let trip = filteredTrips[indexPath.row]
    navigationController?.pushViewController(TripDetailVC(trip: trip.viewModel), animated: true)
  }
}

extension TripsVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    applySnapshot()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.text = ""
      applySnapshot()
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    if !searchBar.text!.isEmpty {
      applySnapshot()
    }
  }
}
