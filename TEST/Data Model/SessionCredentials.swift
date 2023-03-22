//
//  SessionCredentials.swift

//
//    on 15.11.2021.
//

import Foundation

struct SessionCredentials: Codable {
 
  var sessionToken: String
  var userEmail: String
  var deviceKey: String
  var refreshToken: String
  
}
