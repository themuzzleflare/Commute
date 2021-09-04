import Foundation
import UIKit
import TinyConstraints

extension UIActivityIndicatorView {
  static var mediumAnimating: UIActivityIndicatorView {
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    activityIndicatorView.startAnimating()
    activityIndicatorView.width(100)
    activityIndicatorView.height(100)
    return activityIndicatorView
  }
}
