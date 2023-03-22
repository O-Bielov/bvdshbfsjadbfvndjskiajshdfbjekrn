//
//  AppDelegate.swift

//
//    on 19.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      UITextField.appearance().tintColor = .hex("FFF501")
      UITextView.appearance().tintColor = .hex("FFF501")

      return true
    }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    AppDelegateProxy.shared.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
}
