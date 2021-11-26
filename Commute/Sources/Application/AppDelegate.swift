import CoreData
import SwiftDate
import AlamofireNetworkActivityIndicator
import Firebase
import FirebaseAppCheck
import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NetworkActivityIndicatorManager.shared.isEnabled = true
    SwiftDate.defaultRegion = .current
    registerDefaults()
    AppCheck.setAppCheckProviderFactory(CommuteAppCheckProviderFactory())
    FirebaseApp.configure()
    return true
  }

  private func registerDefaults() {
    do {
      let settingsData = try Data(contentsOf: .settingsBundle.appendingPathComponent("Root.plist"))
      let settingsPlist = try PropertyListSerialization.propertyList(from: settingsData, format: nil) as? [String: Any]
      let settingsPreferences = settingsPlist?["PreferenceSpecifiers"] as? [[String: Any]]
      var defaults = [String: Any]()

      settingsPreferences?.forEach { (preference) in
        if let key = preference["Key"] as? String {
          defaults[key] = preference["DefaultValue"]
        }
      }

      UserDefaults.commute.register(defaults: defaults)
    } catch {
      fatalError("Registering defaults failed: \(error.localizedDescription)")
    }
  }

  // MARK: - UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Main Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: - Core Data Stack

  static var persistentContainer: NSPersistentContainer {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  }

  static var viewContext: NSManagedObjectContext {
    let viewContext = persistentContainer.viewContext
    viewContext.automaticallyMergesChangesFromParent = true
    return viewContext
  }

  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "Commute")

    let description = container.persistentStoreDescriptions.first
    description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

    let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
    description?.setOption(true as NSNumber, forKey: remoteChangeKey)

    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    return container
  }()
}
