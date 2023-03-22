//
//  AppDelegateProxy.swift

//
//    on 11.11.2021.
//

import UIKit

final class AppDelegateProxy {

  let didReceiveRemoteNotificationToken = Pipe<String>()
  
  static let shared = AppDelegateProxy()
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken
        .map { String(format: "%02.2hhx", $0) }
        .joined()
    
     didReceiveRemoteNotificationToken.send(token)
  }
  
}
