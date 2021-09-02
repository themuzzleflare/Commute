import Foundation
import UIKit

extension UIStackView {
  static func backgroundStack(for labels: [UILabel]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: labels)
    stackView.axis = .vertical
    stackView.alignment = .center
    return stackView
  }
}
