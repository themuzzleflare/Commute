import Foundation
import TfNSW

protocol StopSequenceDelegate: AnyObject {
  func didSelectStop(_ stop: TripRequestResponseJourneyLegStop)
}
