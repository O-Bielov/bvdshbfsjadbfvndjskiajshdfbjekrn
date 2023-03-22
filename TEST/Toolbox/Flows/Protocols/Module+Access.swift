//
//  Module+Access.swift

//
//    on 10.02.2021.
//

import Foundation

extension Module {
  
  var serviceProvider: ServiceProviding {
    lookup(self, \.parent, ServiceProviding.self)!
  }
  
  var requestExecutor: RequestExecuting {
    serviceProvider.services.getService()
  }
  
  var errorClassifier: ErrorClassifier {
    serviceProvider.services.getService()
  }
 
  var preferences: Preferences {
    serviceProvider.services.getService()
  }
  
  var localNotificationScheduler: LocalNotificationScheduler {
    serviceProvider.services.getService()
  }
  
}
