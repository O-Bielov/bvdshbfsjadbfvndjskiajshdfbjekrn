//
//  Bundle+AppInfo.swift

//
//    on 21.12.2020.
//

import Foundation

extension Bundle {
  
  var displayName: String? {
    infoDictionary?["CFBundleName"] as? String
  }
  
  var versionName: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }
  
}
