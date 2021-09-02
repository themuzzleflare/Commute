import UIKit
import AsyncDisplayKit
import CloudKit
import TinyConstraints

final class StationsVC: ASViewController {
  private enum Section {
    case main
  }

  private typealias Snapshot = NSDiffableDataSourceSnapshot<SortedStations, Station>
  private typealias ByDistanceSnapshot = NSDiffableDataSourceSnapshot<Section, Station>
  private typealias ByDistanceDataSource = UITableViewDiffableDataSource<Section, Station>

  private lazy var dataSource = makeDataSource()
  private lazy var byDistanceDataSource = makeByDistanceDataSource()

  private lazy var searchController: UISearchController = {
    let searchController = UISearchController()
    searchController.searchBar.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.searchBarStyle = .minimal
    return searchController
  }()

  private lazy var segmentedControl = ASDisplayNode { () -> UISegmentedControl in
    let segmentedControl = UISegmentedControl(items: ["By Name", "By Distance"])
    segmentedControl.selectedSegmentIndex = self.byName ? 0 : 1
    segmentedControl.addTarget(self, action: #selector(self.changedSelection(_:)), for: .valueChanged)
    return segmentedControl
  }

  private var byName: Bool = true {
    didSet {
      byName ? byDistanceTableNode.removeFromSupernode() : tableNode.removeFromSupernode()
      byName ? displayNode.addSubnode(tableNode) : displayNode.addSubnode(byDistanceTableNode)
      byName ? applySnapshot() : applyByDistanceSnapshot()
    }
  }

  private var noStations: Bool = false
  private var noByDistanceStations: Bool = false

  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let byDistanceTableView = UITableView(frame: .zero, style: .grouped)

  private lazy var tableNode = ASDisplayNode { () -> UITableView in
    return self.tableView
  }

  private lazy var byDistanceTableNode = ASDisplayNode { () -> UITableView in
    return self.byDistanceTableView
  }

  private var stations = [Station]() {
    didSet {
      noStations = stations.isEmpty
      applySnapshot()
    }
  }

  private var byDistanceStations = [Station]() {
    didSet {
      noByDistanceStations = byDistanceStations.isEmpty
      applyByDistanceSnapshot()
    }
  }

  private var error: CKError?
  private var byDistanceError: CKError?

  private var groupedStations: [String: [Station]] {
    return Dictionary(
      grouping: stations,
      by: { String($0.name.prefix(1)) }
    )
  }

  private var keys: [String] {
    return groupedStations.keys.sorted()
  }

  private var sortedStations: [(key: String, value: [Station])] {
    return groupedStations.sorted { $0.key < $1.key }
  }

  private var sections = [SortedStations]()

  // UITableViewDiffableDataSource
  private class DataSource: UITableViewDiffableDataSource<SortedStations, Station> {
    weak var parent: StationsVC! = nil

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let firstStation = itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
      guard let section = snapshot().sectionIdentifier(containingItem: firstStation) else { return nil }
      return section.id.capitalized
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
      return parent.keys.map { $0.capitalized }
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
      return parent.keys.map { $0.capitalized }.firstIndex(of: title)!
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
    byName ? displayNode.addSubnode(tableNode) : displayNode.addSubnode(byDistanceTableNode)
    configureNavigation()
    configureToolbar()
    configureTableView()
    configureByDistanceTableView()
    applySnapshot()
    applyByDistanceSnapshot()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    switch byName {
    case true:
      tableNode.frame = displayNode.bounds
    case false:
      byDistanceTableNode.frame = displayNode.bounds
    }
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
    setToolbarItems([UIBarButtonItem(customView: segmentedControl.view)], animated: false)
  }

  @objc private func changedSelection(_ segmentedControl: UISegmentedControl) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      byName = true
    case 1:
      byName = false
    default:
      break
    }
  }

  @objc private func close() {
    navigationController?.dismiss(animated: true)
  }

  private func configureTableView() {
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "stationCell")
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func configureByDistanceTableView() {
    byDistanceTableView.dataSource = byDistanceDataSource
    byDistanceTableView.delegate = self
    byDistanceTableView.register(SubtitleCell.self, forCellReuseIdentifier: "stationCell")
    byDistanceTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func makeDataSource() -> DataSource {
    let ds = DataSource(
      tableView: tableView,
      cellProvider: { (tableView, indexPath, station) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)
        cell.separatorInset = .zero
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .newFrankRegular(size: UIFont.labelFontSize)
        cell.textLabel?.text = station.shortName
        return cell
      }
    )
    ds.defaultRowAnimation = .middle
    return ds
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    fetchStations()
  }

  private func makeByDistanceDataSource() -> ByDistanceDataSource {
    let ds = ByDistanceDataSource(
      tableView: byDistanceTableView,
      cellProvider: { (tableView, indexPath, station) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! SubtitleCell
        cell.separatorInset = .zero
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .newFrankRegular(size: UIFont.labelFontSize)
        cell.textLabel?.text = station.shortName
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.detailTextLabel?.font = .newFrankRegular(size: UIFont.smallSystemFontSize)
        cell.detailTextLabel?.text = "\(NumberFormatter.twoDecimalPlaces.string(from: station.location.distance(from: self.locationManager?.location ?? CLLocation()).kilometres.nsNumber) ?? "") km"
        return cell
      }
    )
    ds.defaultRowAnimation = .middle
    return ds
  }

  private func applySnapshot(animate: Bool = true) {
    sections = sortedStations.map { SortedStations(id: $0.key, stations: $0.value) }
    var snapshot = Snapshot()
    snapshot.appendSections(sections)
    sections.forEach { snapshot.appendItems($0.stations, toSection: $0) }
    if snapshot.itemIdentifiers.isEmpty && error == nil {
      if stations.isEmpty && !noStations {
        tableView.backgroundView = {
          let view = UIView(frame: tableView.bounds)
          let loadingIndicator = UIActivityIndicatorView.mediumAnimating
          view.addSubview(loadingIndicator)
          loadingIndicator.centerInSuperview()
          return view
        }()
      } else {
        tableView.backgroundView = {
          let view = UIView(frame: tableView.bounds)
          let label = UILabel.backgroundLabelTitle(with: searchController.searchBar.text!.isEmpty ? "No Stations" : "No Results")
          view.addSubview(label)
          label.centerInSuperview()
          return view
        }()
      }
    } else {
      if let error = error {
        tableView.backgroundView = {
          let view = UIView(frame: tableView.bounds)
          let titleLabel = UILabel.backgroundLabelTitle(with: error.title)
          let descriptionLabel = UILabel.backgroundLabelDescription(with: error.description)
          let stackView = UIStackView.backgroundStack(for: [titleLabel, descriptionLabel])
          view.addSubview(stackView)
          stackView.horizontalToSuperview(insets: .horizontal(16))
          stackView.centerInSuperview()
          return view
        }()
      } else {
        if tableView.backgroundView != nil { tableView.backgroundView = nil }
      }
    }

    dataSource.apply(snapshot, animatingDifferences: animate)
  }

  private func applyByDistanceSnapshot(animate: Bool = true) {
    var snapshot = ByDistanceSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(byDistanceStations)
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
      byDistanceTableView.backgroundView = {
        let view = UIView(frame: byDistanceTableView.bounds)
        let button = UIButton.locationServicesButton
        view.addSubview(button)
        button.centerInSuperview()
        return view
      }()
    } else {
      if snapshot.itemIdentifiers.isEmpty && byDistanceError == nil {
        if byDistanceStations.isEmpty && !noByDistanceStations {
          byDistanceTableView.backgroundView = {
            let view = UIView(frame: byDistanceTableView.bounds)
            let loadingIndicator = UIActivityIndicatorView.mediumAnimating
            view.addSubview(loadingIndicator)
            loadingIndicator.centerInSuperview()
            return view
          }()
        } else {
          byDistanceTableView.backgroundView = {
            let view = UIView(frame: byDistanceTableView.bounds)
            let label = UILabel.backgroundLabelTitle(with: searchController.searchBar.text!.isEmpty ? "No Stations" : "No Results")
            view.addSubview(label)
            label.centerInSuperview()
            return view
          }()
        }
      } else {
        if let error = byDistanceError {
          byDistanceTableView.backgroundView = {
            let view = UIView(frame: byDistanceTableView.bounds)
            let titleLabel = UILabel.backgroundLabelTitle(with: error.title)
            let subtitleLabel = UILabel.backgroundLabelDescription(with: error.description)
            let stackView = UIStackView.backgroundStack(for: [titleLabel, subtitleLabel])
            view.addSubview(stackView)
            stackView.horizontalToSuperview(insets: .horizontal(16))
            stackView.centerInSuperview()
            return view
          }()
        } else {
          if byDistanceTableView.backgroundView != nil { byDistanceTableView.backgroundView = nil }
        }
      }
    }
    byDistanceDataSource.apply(snapshot, animatingDifferences: animate)
  }

  private func fetchStations() {
    CKFacade.searchStation(searchString: searchController.searchBar.text) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.error = nil
          self.stations = stations
        case .failure(let error):
          self.error = error
          self.stations = []
          let ac = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Dismiss", style: .default)
          ac.addAction(cancelAction)
          self.present(ac, animated: true)
        }
      }
    }

    CKFacade.searchStation(searchString: searchController.searchBar.text, currentLocation: locationManager?.location) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let stations):
          self.byDistanceError = nil
          self.byDistanceStations = CLLocationManager.authorizationStatus() == .authorizedWhenInUse ? stations : []
        case .failure(let error):
          self.byDistanceError = error
          self.byDistanceStations = []
          let ac = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Dismiss", style: .default)
          ac.addAction(cancelAction)
          self.present(ac, animated: true)
        }
      }
    }
  }
}

extension StationsVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    switch byName {
    case true:
      if let station = dataSource.itemIdentifier(for: indexPath) {
        navigationController?.pushViewController(StationDetailVC(station: station), animated: true)
      }
    case false:
      if let station = byDistanceDataSource.itemIdentifier(for: indexPath) {
        navigationController?.pushViewController(StationDetailVC(station: station), animated: true)
      }
    }
  }
}

extension StationsVC: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    fetchStations()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.text = ""
      fetchStations()
    }
  }
}
