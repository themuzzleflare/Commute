import UIKit
import AsyncDisplayKit
import TinyConstraints
import TfNSW

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
    navigationItem.title = trip.tripName
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
    APIFacade.fetchJourneys(from: trip.fromStopId, to: trip.toStopId) { (result) in
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

    return {
      return JourneyCellNode(journey: journey)
    }
  }
}

extension TripDetailVC: ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    let journey = journeys[indexPath.row]

    tableNode.deselectRow(at: indexPath, animated: true)

    if let legs = journey.legs {
      if legs.count == 1 {
        if let stops = legs[0].stopSequence {
          navigationController?.pushViewController(StopSequenceVC(stops: stops), animated: true)
        } else {
          navigationController?.pushViewController(JourneyDetailVC(legs: legs), animated: true)
        }
      } else {
      navigationController?.pushViewController(JourneyDetailVC(legs: legs), animated: true)
      }
    }
  }
}
