import UIKit
import Rswift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var savedShortcutItem: UIApplicationShortcutItem!
  let notificationCentre = UNUserNotificationCenter.current()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    if let shortcutItem = connectionOptions.shortcutItem {
      savedShortcutItem = shortcutItem
    }

    let window = UIWindow(windowScene: windowScene)

    window.tintColor = R.color.accentColor()
    window.rootViewController = TabBarController()
    window.makeKeyAndVisible()

    self.window = window

    notificationCentre.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
      if let error = error {
        print(error.localizedDescription)
      } else if granted {
        print("Notifications granted")
      }
    }
  }

  func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    completionHandler(handleShortcutItem(shortcutItem: shortcutItem))
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    if savedShortcutItem != nil {
      _ = handleShortcutItem(shortcutItem: savedShortcutItem)
    }

    UIApplication.shared.applicationIconBadgeNumber = 0
  }

  func sceneWillResignActive(_ scene: UIScene) {
    if savedShortcutItem != nil {
      savedShortcutItem = nil
    }
  }

  private func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
    if let tbc = window?.rootViewController as? TabBarController,
       let actionTypeValue = ShortcutType(rawValue: shortcutItem.type) {
      switch actionTypeValue {
      case .trips:
        tbc.selectedIndex = 0
      case .stations:
        tbc.selectedIndex = 1
      case .tools:
        tbc.selectedIndex = 2
      case .about:
        tbc.selectedIndex = 3
      }
    }
    return true
  }

  private func checkPermissionStatus() {
    CKFacade.checkPermissionStatus { (result) in
      switch result {
      case .success(let status):
        switch status {
        case .initialState:
          self.requestPermission()
        case .couldNotComplete:
          break
        case .denied:
          self.requestPermission()
        case .granted:
          break
        @unknown default:
          self.requestPermission()
        }
      case .failure(let error):
        print("\(error.title): \(error.description)")
      }
    }
  }

  private func requestPermission() {
    CKFacade.requestDiscoverability { (result) in
      switch result {
      case .success(let status):
        print("\(status.title): \(status.description)")
      case .failure(let error):
        print("\(error.title): \(error.description)")
      }
    }
  }

  private func fetchAccountStatus() {
    CKFacade.fetchAccountStatus { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let status):
          print("\(status.title): \(status.description)")
          self.checkPermissionStatus()
        case .failure(let error):
          print("\(error.title): \(error.description)")
        }
      }
    }
  }

  private func saveTripCreatedSubscription() {
    CKFacade.saveTripCreatedSubscription { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let subscription):
          print("Successfully created subscription with ID: \(subscription.subscriptionID)")
        case .failure(let error):
          let ac = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
          let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
          ac.addAction(dismissAction)
          self.window?.rootViewController?.present(ac, animated: true)
        }
      }
    }
  }

  private func saveTripDeletedSubscription() {
    CKFacade.saveTripDeletedSubscription { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(let subscription):
          print("Successfully created subscription with ID: \(subscription.subscriptionID)")
        case .failure(let error):
          let ac = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
          let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
          ac.addAction(dismissAction)
          self.window?.rootViewController?.present(ac, animated: true)
        }
      }
    }
  }
}
