import UIKit
import AsyncDisplayKit
import CoreData
import TinyConstraints
import Rswift

final class TripsVC: ASViewController {
  private let tableView = UITableView(frame: .zero, style: .grouped)

  private lazy var tableNode = ASDisplayNode { () -> UIView in
    return self.tableView
  }

  private var trips: [Trip] = Trip.fetchAll() {
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
    return trips.filter {
      (trip) in
      switch searchController.searchBar.selectedScopeButtonIndex {
      case 0:
        return searchController.searchBar.text!.isEmpty || trip.fromName.localizedStandardContains(searchController.searchBar.text!)
      case 1:
        return searchController.searchBar.text!.isEmpty || trip.toName.localizedStandardContains(searchController.searchBar.text!)
      default:
        return searchController.searchBar.text!.isEmpty || trip.fromName.localizedStandardContains(searchController.searchBar.text!)
      }
    }
  }

  private enum Section {
    case main
  }

  private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Trip>

  private lazy var dataSource = makeDataSource()
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

  private class DataSource: UITableViewDiffableDataSource<Section, Trip> {
    weak var parent: TripsVC! = nil

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      guard let trip = itemIdentifier(for: indexPath) else { return }

      switch editingStyle {
      case .delete:
        AppDelegate.viewContext.delete(trip)

        do {
          try AppDelegate.viewContext.save()

          parent.fetchTrips()
        } catch {
          DispatchQueue.main.async {
            let ac = UIAlertController(title: "Error", message: "An unknown error was encountered while deleting this trip.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .default)
            ac.addAction(cancelAction)
            self.parent.present(ac, animated: true)
          }
        }
      default: break
      }
    }
  }

  override init() {
    super.init()
    dataSource.parent = self
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    displayNode.addSubnode(tableNode)
    configureObserver()
    configureToolbar()
    configureNavigation()
    configureTableView()
    applySnapshot()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableNode.frame = displayNode.bounds
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
    tableView.setEditing(editing, animated: animated)
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

  private func configureTableView() {
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tripCell")
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func makeDataSource() -> DataSource {
    let ds = DataSource(
      tableView: tableView,
      cellProvider: {
        (tableView, indexPath, trip) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = .zero
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = R.font.newFrankRegular(size: UIFont.labelFontSize)
        cell.textLabel?.text = "\(trip.fromName.replacingOccurrences(of: " Station", with: "")) to \(trip.toName.replacingOccurrences(of: " Station", with: ""))"
        return cell
      }
    )
    ds.defaultRowAnimation = .middle
    return ds
  }

  private func applySnapshot(animate: Bool = true) {
    DispatchQueue.main.async {
      [self] in
      var snapshot = Snapshot()

      snapshot.appendSections([.main])
      snapshot.appendItems(filteredTrips)

      if snapshot.itemIdentifiers.isEmpty {
        if trips.isEmpty {
          if isEditing { setEditing(false, animated: true) }
          if editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = false }
          tableView.backgroundView = {
            let view = UIView(frame: tableView.bounds)

            let titleLabel = UILabel()
            let subtitleLabel = UILabel()

            let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])

            view.addSubview(vStack)

            vStack.horizontalToSuperview(insets: .horizontal(16))
            vStack.centerInSuperview()
            vStack.axis = .vertical
            vStack.alignment = .center

            titleLabel.textAlignment = .center
            titleLabel.textColor = .placeholderText
            titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
            titleLabel.text = "No Trips"

            subtitleLabel.textAlignment = .center
            subtitleLabel.textColor = .placeholderText
            subtitleLabel.font = .preferredFont(forTextStyle: .body)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.text = "Add a trip by tapping the add button in the top-right corner."

            return view
          }()
        } else {
          tableView.backgroundView = {
            let view = UIView(frame: tableView.bounds)

            let titleLabel = UILabel()

            view.addSubview(titleLabel)

            titleLabel.centerInSuperview()
            titleLabel.textAlignment = .center
            titleLabel.textColor = .placeholderText
            titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
            titleLabel.text = "No Results"

            return view
          }()
        }
      } else {
        if !editBarButtonItem.isEnabled { editBarButtonItem.isEnabled = true }
        if tableView.backgroundView != nil { tableView.backgroundView = nil }
      }

      dataSource.apply(snapshot, animatingDifferences: animate)
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
    let vc = NavigationController(rootViewController: AddTripFromVC())
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }

  @objc private func removeAllTrips() {
    let ac = UIAlertController(title: "Confirmation", message: "Are you sure you'd like to remove all saved trips? This cannot be undone.", preferredStyle: .actionSheet)
    let confirmAction = UIAlertAction(title: "Remove All", style: .destructive, handler: { _ in
      Trip.deleteAll()
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    ac.addAction(confirmAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }
}

extension TripsVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if let trip = dataSource.itemIdentifier(for: indexPath) {
      navigationController?.pushViewController(TripDetailVC(trip: trip), animated: true)
    }
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
