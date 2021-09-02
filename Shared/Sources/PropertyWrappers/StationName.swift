import Foundation

@propertyWrapper struct StationName {
  private var string: String = ""

  var wrappedValue: String {
    get { return string }
    set {
      string = newValue
        .replacingOccurrences(of: "Macquarie University", with: "Macquarie Uni")
        .replacingOccurrences(of: "International Airport", with: "Intnl Airport")
    }
  }

  init(wrappedValue: String) {
    self.wrappedValue = wrappedValue
  }
}
