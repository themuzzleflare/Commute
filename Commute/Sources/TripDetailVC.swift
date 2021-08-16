import UIKit
import AsyncDisplayKit
import SwiftDate
import TinyConstraints
import Rswift

final class TripDetailVC: ASDKViewController<ASTableNode> {
  private let tableNode = ASTableNode(style: .grouped)

  private var trip: Trip

  private var journeys: [TripRequestResponseJourney] = [] {
    didSet {
      tableNode.reloadData()
      tableNode.view.refreshControl?.endRefreshing()
      if tableNode.view.backgroundView != nil { tableNode.view.backgroundView = nil }
    }
  }

  init(trip: Trip) {
    self.trip = trip
    super.init(node: tableNode)
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigation()
    configureTableNode()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchJourneys()
  }

  private func configureNavigation() {
    navigationItem.title = "\(trip.fromName.replacingOccurrences(of: " Station", with: "")) to \(trip.toName.replacingOccurrences(of: " Station", with: ""))"
  }

  private func configureTableNode() {
    tableNode.dataSource = self
    tableNode.delegate = self
    tableNode.view.showsVerticalScrollIndicator = false
    tableNode.view.backgroundView = {
      let view = UIView(frame: tableNode.bounds)

      let loadingIndicator = UIActivityIndicatorView(style: .medium)
      loadingIndicator.startAnimating()

      view.addSubview(loadingIndicator)

      loadingIndicator.centerInSuperview()
      loadingIndicator.width(100)
      loadingIndicator.height(100)

      return view
    }()
  }

  private func fetchJourneys() {
    APIFacade.fetchJourneys(origin: trip.fromStopId, destination: trip.toStopId) {
      (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let journeys):
          self.journeys = journeys
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}

extension TripDetailVC: ASTableDataSource {
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return journeys.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    let journey = journeys[indexPath.row]

    let jObject = Journey(
      fromName: journey.legs?.first?.origin?.disassembledName?.replacingOccurrences(of: " Station", with: ""),
      fromTime: journey.legs?.first?.origin?.departureTimeEstimated?.toDate()?.toString(.time(.short)),
      toName: journey.legs?.last?.destination?.disassembledName?.replacingOccurrences(of: " Station", with: ""),
      toTime: journey.legs?.last?.destination?.arrivalTimeEstimated?.toDate()?.toString(.time(.short)),
      relativeTime: journey.legs?.first?.origin?.departureTimeEstimated?.toDate()?.toRelative(),
      relativeTimeInPast: journey.legs?.first?.origin?.departureTimeEstimated?.toDate()?.isInPast
    )

    return {
      return JourneyCellNode(journey: jObject)
    }
  }
}

extension TripDetailVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let journey = journeys[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    if let legs = journey.legs {
      navigationController?.pushViewController(JourneyDetailVC(legs: legs), animated: true)
    }
  }
}
