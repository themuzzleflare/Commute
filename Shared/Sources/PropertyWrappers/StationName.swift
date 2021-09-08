import Foundation

@propertyWrapper struct StationName {
  private var string: String = ""

  var wrappedValue: String {
    get { return string }
    set {
      string = newValue
        .replacingOccurrences(of: "Macquarie University", with: "Macquarie Uni")
        .replacingOccurrences(of: "International Airport", with: "Intnl Airport")
        .replacingOccurrences(of: "Mount Kuring-gai", with: "Mt. Kuring-Gai")
        .replacingOccurrences(of: "Hawkesbury River", with: "Hwksby River")
    }
  }

  init(wrappedValue: String) {
    self.wrappedValue = wrappedValue
  }
}
