import Foundation
import CloudKit
import UIKit
import SnapKit

extension UIView {
  static func noTripsView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
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
  }

  static func noResultsView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    let titleLabel = UILabel.backgroundLabelTitle(text: "No Results")
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    return view
  }

  static func loadingView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    let loadingIndicator = UIActivityIndicatorView.mediumAnimating
    view.addSubview(loadingIndicator)
    loadingIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    return view
  }

  static func noStationsOrResultsView(for searchController: UISearchController, frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    let label = UILabel.backgroundLabelTitle(text: searchController.searchBar.text!.isEmpty ? "No Stations" : "No Results")
    view.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    return view
  }

  static func errorView(for error: CKError, frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    let titleLabel = UILabel.backgroundLabelTitle(text: error.title)
    let descriptionLabel = UILabel.backgroundLabelDescription(text: error.description)
    let stackView = UIStackView.backgroundStack(for: [titleLabel, descriptionLabel])
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(16)
      make.right.equalToSuperview().inset(16)
      make.center.equalToSuperview()
    }
    return view
  }

  static func locationServicesView(frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    let button = UIButton.locationServicesButton
    view.addSubview(button)
    button.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    return view
  }
}
