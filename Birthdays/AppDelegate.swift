import UIKit
import Firebase
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static var appDelegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
  
  var window: UIWindow?
  var contactStore = CNContactStore()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
  
  func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
    let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    
    switch authorizationStatus {
    case .authorized:
      completionHandler(true)
      
    case .denied, .notDetermined:
      self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
        if access {
          completionHandler(access)
        } else {
          if authorizationStatus == CNAuthorizationStatus.denied {
            DispatchQueue.main.async {
              let warningMessage = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
              Helper.show(message: warningMessage)
            }
          }
        }
      })
      
    default:
      completionHandler(false)
    }
  }
}
