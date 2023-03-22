//
//  Preferences+Access.swift

//
//    on 04.11.2021.
//

import Foundation

struct UserInfo: Codable {
  
  let email: String
  
}

extension Preferences {
  
  var userInfo: UserInfo {
    get { get(fallback: UserInfo(email: "")) }
    set { set(newValue) }
  }
  
}
